//
//  CollectionView.swift
//  Nothing
//
//  Created by Jose Benitez on 2/20/24.
//

import UIKit
import CoreData

class NothingCollectionView: UICollectionView {
    
    private let notifications: NothingNotificationManager = NothingNotificationManager(notificationCenter: .default)
    private var editingNote: Note?
    private var pendingText: String?
    
    lazy var persistentContainer: NSPersistentContainer = {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        return appDelegate!.persistenceContainer
    }()

    lazy var fetchedResultsController: NSFetchedResultsController<Note> = {
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: Note.Dates.dateCreated, ascending: true)]
        let controller: NSFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                                managedObjectContext: persistentContainer.viewContext,
                                                                                sectionNameKeyPath: Note.Dates.dateCreated,
                                                                                cacheName: nil)
        controller.delegate = self
        do {
            try controller.performFetch()
        } catch {
            fatalError("\(#function) failed to perform fetch: \(error)")
        }
        
        return controller
    }()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        configure()

        notifications.addEventsObserver(self)
    }
    
    deinit {
        notifications.removeObserverObjects()
    }
    
    func configure() {
        dataSource = self
        delegate = self
        register(NothingCollectionViewCell.self,
                 forCellWithReuseIdentifier: NothingCollectionViewCell.nothingCollectionViewCellId)
        register(NothingCollectionViewReusableView.self,
                 forSupplementaryViewOfKind: NothingCollectionViewReusableView.sectionHeader,
                 withReuseIdentifier: NothingCollectionViewReusableView.sectionHeader)
        register(NothingCollectionViewReusableView.self,
                 forSupplementaryViewOfKind: NothingCollectionViewReusableView.sectionFooter,
                 withReuseIdentifier: NothingCollectionViewReusableView.sectionFooter)
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        accessibilityLabel = "NothingCollectionView"
    }
    
}

extension NothingCollectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: NothingCollectionViewReusableView.sectionHeader,
                                                                                      withReuseIdentifier: NothingCollectionViewReusableView.sectionHeader,
                                                                                      for: indexPath) as? NothingCollectionViewReusableView
        else { return UICollectionReusableView() }
        
        let note = fetchedResultsController.object(at: indexPath)
        if let date = note.dateCreated {
            supplementaryView.label.text = SampleNotes.formatHeaderTitle(date)
        }
        
        return supplementaryView
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let itemsInSection = fetchedResultsController.sections?[section].numberOfObjects ?? 1
        return itemsInSection
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NothingCollectionViewCell.nothingCollectionViewCellId, for: indexPath) as? NothingCollectionViewCell
        {
            let note = fetchedResultsController.object(at: indexPath)
            cell.setNote(note, for: indexPath)
            
            return cell
        }
        else {
            return UICollectionViewCell()
        }
    }
    
}

extension NothingCollectionView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let _ = collectionView.dequeueReusableCell(withReuseIdentifier: NothingCollectionViewCell.nothingCollectionViewCellId, for: indexPath) as? NothingCollectionViewCell else { return }
        guard let notes = fetchedResultsController.fetchedObjects else { return }
        let note = fetchedResultsController.object(at: indexPath)
        
        notifications.postTextViewWillResignNotification(nil, object: nil)
    }
}

extension NothingCollectionView {
    @objc func textViewWillResignEditing(_ notification: Notification) {
        endEditing(true)
    }
    
    @objc func textViewDidEndEditingText(_ notification: Notification) {
        guard let info = notification.userInfo,
              let text = info["textString"] as? String,
              text.count > 0,
              let textData = text.data(using: .utf8),
              let _ = notification.object as? NothingTextView
        else { return }
        
        let taskContext = newBackgroundTaskContext()
        taskContext.perform {
            let note = Note(context: taskContext, data: textData)
            
            do {
                try taskContext.save()
            } catch {
                print(error)
            }
        }
    }
    
    @objc func deleteNote() {
        print("deleteNote...")
    }
    
    private func newBackgroundTaskContext() -> NSManagedObjectContext {
        let taskContext = persistentContainer.newBackgroundContext()
//        taskContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
//        taskContext.undoManager = nil
        return taskContext
    }
    
    private func saveNewNote() {
        let taskContext = newBackgroundTaskContext()
        let textData = pendingText!.data(using: .utf8)!
        let note = Note(context: taskContext, data: textData)
        taskContext.perform {
            do {
                try taskContext.save()
            } catch {
                print(error)
            }
        }
    }
    
    private func fetchAndQueryNote() async throws {
//        let taskContext = newBackgroundTaskContext()
    }
    
    @objc func didShowKeyboard(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }


        // In iOS 16.1 and later, the keyboard notification object is the screen the keyboard appears on.
        guard let _ = notification.object as? UIScreen,
              // Get the keyboard’s frame at the end of its animation.
              let _ = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let visibleCellOnScreen = visibleCells.compactMap { $0 as? NothingCollectionViewCell }
        let isCellSelected = visibleCellOnScreen.first(where: { $0.textViewIsFirstResponder })!
                
        scrollRectToVisible(isCellSelected.frame, animated: true)
    }
}

extension NothingCollectionView: NSFetchedResultsControllerDelegate {

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        reloadData()
    }
    
    func controller(_ controller: NSFetchedResultsController<any NSFetchRequestResult>, didChange sectionInfo: any NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        guard let objects = sectionInfo.objects as? [Note] else { return }
        
        switch type {
        case .insert:
            print("added note at section: \(sectionIndex)")
        case .delete:
            break
        case .move:
            break
        case .update:
            print("updated note at section: \(sectionIndex)")
        @unknown default:
            break
        }
    }
    
}
