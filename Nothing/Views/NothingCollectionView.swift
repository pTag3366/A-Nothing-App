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
    
    private let logger = Logger(subsystem: "com.josephk.Nothing", category: "persistence")
    
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
        let sectionDate: String
        sectionDate = indexPath.section == 0 ? SampleNotes.formatHeaderTitle(Date()) : section.name
        supplementaryView.setSectionTitle(sectionDate)
        
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
            guard let _ = note.uuid else { return cell }
            cell.setNote(note, for: indexPath)
            return cell
        }
        else {
            return UICollectionViewCell()
        }
    }
    
    @objc func scrollToTop() {
        scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
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
              let newData = newString.data(using: .utf8),
              let indexPath = textView.indexPath
        else { return logger.error("\(NoteError.incompleteData(description: "\(#function)"))") }
        
        let task = Note.newBackgroundTaskContext(persistentContainer)
        let currentNote = fetchedResultsController.object(at: indexPath)
        let currentData = currentNote.textData ?? Data()
        let currentText = String(data: currentData, encoding: .utf8) ?? ""
        
        if (newString.isEmpty && !currentText.isEmpty || noteTextDidChanged(from: currentText, to: newString) && (indexPath != IndexPath(item: 0, section: 0))) {
            updateNote(note: currentNote, data: newData, task: task)
        } else if (!newString.isEmpty && currentText.isEmpty) {
            let newNote = Note(context: task, data: newData)
            insertNote(with: newNote, task: task)
        }
    }
    
    @objc func deleteNote(_ notification: Notification) {
        logger.debug("\(#function): \(notification)")
        guard let index = notification.userInfo?["indexPath"] as? IndexPath,
              let _ = fetchedResultsController.object(at: index).textData   //veryfy that note has data
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
        logger.debug("\(self.fetchedResultsController.managedObjectContext.updatedObjects.count)")
        let index = self.fetchedResultsController.indexPath(forObject: self.fetchedResultsController.fetchedObjects!.last!)
        scrollToItem(at: index!, at: .bottom, animated: true)
        let isNoteEmpty = String(data: self.fetchedResultsController.object(at: IndexPath(row: 0, section: 0)).textData ?? Data(), encoding: .utf8)
        assert(isNoteEmpty!.isEmpty)
        
    }
    
    func controller(_ controller: NSFetchedResultsController<any NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        guard let note = anObject as? Note else { return }
        
        switch type {
        case .insert:
            logger.debug("added note at section: \(newIndexPath!.section), row: \(newIndexPath!.row)")
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
