//
//  CollectionView.swift
//  Nothing
//
//  Created by Jose Benitez on 2/20/24.
//

import UIKit
import CoreData
import OSLog

class NothingCollectionView: UICollectionView {
    
    private let notifications: NothingNotificationManager = NothingNotificationManager(notificationCenter: .default)
    
    let logger = Logger(subsystem: "com.josephk.Nothing", category: "persistence")
    
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
    
    private var lastIndex: IndexPath? = nil

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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let _ = collectionView.dequeueReusableCell(withReuseIdentifier: NothingCollectionViewCell.nothingCollectionViewCellId, for: indexPath) as? NothingCollectionViewCell else { return }

        endEditing(true)
    }
}

extension NothingCollectionView {
    
    private func noteTextDidChanged(from oldText: String, to newText: String) -> Bool {
        let result = !newText.elementsEqual(oldText)
        logger.debug("\(#function): \(result)")
        return result
    }
    
    @objc func didShowKeyboard(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let _ = notification.object as? UIScreen,
              let _ = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else { return logger.error("\(NoteError.incompleteData(description: "\(#function)"))") }
        
        let visibleCellOnScreen = visibleCells.compactMap { $0 as? NothingCollectionViewCell }
        if let isCellSelected = visibleCellOnScreen.first(where: { $0.textViewIsFirstResponder }) {
            scrollRectToVisible(isCellSelected.frame, animated: true)
        }
    }
    
    @objc func textViewDidEndEditingText(_ notification: Notification) {
        logger.debug("\(#function): \(notification)")
        guard let textView = notification.object as? NothingTextView,
              let newString = textView.text,
              let newData = newString.data(using: .utf8)
        else { return logger.error("\(NoteError.incompleteData(description: "\(#function)"))") }
        logger.debug("\(textView.indexPath)")
        
        let note = fetchedResultsController.object(at: textView.indexPath)
        let currentData = note.textData ?? Data()
        let currentText = String(data: currentData, encoding: .utf8) ?? ""
        let task = Note.newBackgroundTaskContext(persistentContainer)
        if (!newString.isEmpty && currentText.isEmpty) {
            let newNote = Note(context: task, data: newData)
            insertNote(with: newNote, task: task)
        } else if (!currentText.isEmpty && !newString.isEmpty && noteTextDidChanged(from: currentText, to: newString)) {
            updateNote(note: note, data: newData, task: task)
        }
    }
    
    @objc func deleteNote(_ notification: Notification) {
        logger.debug("\(#function): \(notification)")
        guard let index = notification.userInfo?["indexPath"] as? IndexPath,
              let _ = fetchedResultsController.object(at: index).textData
        else {
            return logger.error("\(NoteError.incompleteData(description: "\(#function)"))")
        }
        removeNoteFromViewContext(at: index)
    }
    
    private func updateNote(note: Note, data: Data, task: NSManagedObjectContext) {
        logger.debug("Start batch update request...")
        Note.updateNote(note: note, data: data, task: task)
    }
    
    private func insertNote(with note: Note, task: NSManagedObjectContext) {
        logger.debug("Start batch insert request...")
        Note.insertNote(with: note, task: task)
    }
    
    private func removeNoteFromViewContext(at indexPath: IndexPath) {
        logger.debug("\(#function)")
        Note.removeNoteFromViewContext(store: persistentContainer, controller: fetchedResultsController, at: indexPath)
    }
    
    private func removeNoteFromPersistentStore(_ note: Note) {
        guard let _ = note.textData else { return logger.error("\(NoteError.incompleteData(description: "\(#function)"))") }
        logger.debug("\(#function)")
        Note.removeNoteFromPersistentStore(note, task: Note.newBackgroundTaskContext(persistentContainer))
    }
}

extension NothingCollectionView: NSFetchedResultsControllerDelegate {

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        logger.debug("\(#function)")
        reloadData()
        if let index = lastIndex {
            scrollToItem(at: index, at: .centeredVertically, animated: true)
            lastIndex = nil
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<any NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        guard let note = anObject as? Note else { return }
        
        switch type {
        case .insert:
            logger.debug("added note at section: \(newIndexPath!.section), row: \(newIndexPath!.row)")
            if let lastIndexPath = newIndexPath {
                lastIndex = lastIndexPath
            }
        case .delete:
            removeNoteFromPersistentStore(note)
            if let indexPath = indexPath {
                scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
            }
        case .move:
            break
        case .update:
            logger.debug("updated note at section: \(indexPath!.section), row: \(indexPath!.row)")
        @unknown default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<any NSFetchRequestResult>, didChange sectionInfo: any NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        guard let _ = sectionInfo.objects as? [Note] else { return }
        
        switch type {
        case .insert:
            logger.debug("sectionInfo insert at: \(sectionIndex)")
        case .delete:
            logger.debug("sectionInfo delete at: \(sectionIndex)")
        case .move:
            break
        case .update:
            logger.debug("sectionInfo update at: \(sectionIndex)")
        @unknown default:
            break
        }
    }
    
}
