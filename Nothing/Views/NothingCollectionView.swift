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
    
    lazy var persistentContainer: NSPersistentContainer = {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        return appDelegate!.persistenceContainer
    }()

    lazy var fetchedResultsController: NSFetchedResultsController<Note> = {
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: Note.Dates.dateCreated, ascending: true)]
        let controller: NSFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                                managedObjectContext: persistentContainer.viewContext,
                                                                                sectionNameKeyPath: Note.Dates.dateString,
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
        
        guard let sections = fetchedResultsController.sections, sections.count >= indexPath.section else { return supplementaryView }
        let section = sections[indexPath.section]
        supplementaryView.setSectionTitle(section.name)
        
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
    
    func collectionView(_ collectionView: UICollectionView, shouldBeginMultipleSelectionInteractionAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didBeginMultipleSelectionInteractionAt indexPath: IndexPath) {
        let note = fetchedResultsController.object(at: indexPath)
        deleteNote(note)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let _ = collectionView.dequeueReusableCell(withReuseIdentifier: NothingCollectionViewCell.nothingCollectionViewCellId, for: indexPath) as? NothingCollectionViewCell else { return }

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
              let textData = text.data(using: .utf8)
        else { return }
        
        let taskContext = newBackgroundTaskContext()
        
        taskContext.perform {
            let note = Note(context: taskContext, data: textData)
            
            do {
                let noteDict = try Notes(from: note)
                let batchInsert = NSBatchInsertRequest(entity: Note.entity(), dictionaryHandler: { dict in
                    dict.addEntries(from: noteDict.dictionaryValue)
                    return true
                })
                try taskContext.save()
            } catch {
                print(error)
            }
        }
    }
    
    func deleteNote(_ note: Note) {
        guard let info = note.textData else { return }
        let viewContext = persistentContainer.viewContext
        viewContext.perform {
            let objToDelete = viewContext.object(with: note.objectID)
            viewContext.delete(objToDelete)
        }
    }
    
    func removeNote(_ note: Note) {
        let taskContext = newBackgroundTaskContext()
        taskContext.perform {
            let deleteRequest = NSBatchDeleteRequest(objectIDs: [note.objectID])
            let fetchResult = try? taskContext.execute(deleteRequest)
            let deleteResult = fetchResult as? NSBatchDeleteResult
            let result = deleteResult?.result
        }
    }
    
    private func newBackgroundTaskContext() -> NSManagedObjectContext {
        let taskContext = persistentContainer.newBackgroundContext()
//        taskContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
//        taskContext.undoManager = nil
        return taskContext
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
    
    func controller(_ controller: NSFetchedResultsController<any NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        guard let object = anObject as? Note else { return }
        
        switch type {
        case .insert:
            print("added note at section: \(newIndexPath!.section), row: \(newIndexPath!.row)")
        case .delete:
            removeNote(object)
            print("deleted note at section: \(indexPath!.section), row: \(indexPath!.row)")
        case .move:
            break
        case .update:
            print("updated note at section: \(indexPath!.section), row: \(indexPath!.row)")
        @unknown default:
            break
        }
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
