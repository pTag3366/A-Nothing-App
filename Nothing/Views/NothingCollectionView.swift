//
//  CollectionView.swift
//  Nothing
//
//  Created by Jose Benitez on 2/20/24.
//

import UIKit
import CoreData

class NothingCollectionView: UICollectionView {
    
    let textViewWillResignFirstResponder = Notification.Name("textViewWillResign")
    
    lazy var persistentContainer: NSPersistentContainer = {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        return appDelegate!.persistenceContainer
    }()

    lazy var fetchedResultsController: NSFetchedResultsController<Note> = {
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: Note.Date.dateCreated, ascending: true)]
        let controller: NSFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                                managedObjectContext: persistentContainer.viewContext,
                                                                                sectionNameKeyPath: nil,
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

        NotificationCenter.default.addObserver(self, selector: #selector(NothingCollectionView.didShowKeyboard(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(NothingCollectionView.textViewWillResign(_:)), name: textViewWillResignFirstResponder, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
        supplementaryView.label.text = NothingCollectionViewReusableView.sectionHeader
        
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
            let text = String(data: note.textData ?? Data(), encoding: .utf8) ?? "Couldn't load data"
            cell.textView.setPlaceholderText(with: text)
//            let placeholder = indexPath.commaSeparatedStringRepresentation
//            cell.textView.setPlaceholderText(with: placeholder)
//            cell.setAccessibilityLabel(with: placeholder)
            return cell
        }
        else {
            return UICollectionViewCell()
        }
    }
    
}

extension NothingCollectionView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NothingCollectionViewCell.nothingCollectionViewCellId, for: indexPath) as? NothingCollectionViewCell else { return }

        NotificationCenter.default.post(name: textViewWillResignFirstResponder, object: nil, userInfo: nil)

    }
}

extension NothingCollectionView {
    @objc func textViewWillResign(_ notification: Notification) {
        endEditing(true)
    }
    
    @objc func willDisplayKeyboard(_ notification: Notification) {

    }
    
    @objc func didShowKeyboard(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }


        // In iOS 16.1 and later, the keyboard notification object is the screen the keyboard appears on.
        guard let screen = notification.object as? UIScreen,
              // Get the keyboard’s frame at the end of its animation.
              let keyboardFrameEnd = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let visibleCellOnScreen = visibleCells.compactMap { $0 as? NothingCollectionViewCell }
        let isCellSelected = visibleCellOnScreen.first(where: { $0.textView.isFirstResponder })!
                
        scrollRectToVisible(isCellSelected.frame, animated: true)
    }
    
    @objc func willHideKeyboard(_ notification: Notification) {

    }
    
    @objc func didHideKeyboard(_ notification: Notification) {

    }
}

extension NothingCollectionView: NSFetchedResultsControllerDelegate {
    
}
