//
//  ViewController.swift
//  Nothing
//
//  Created by Jose Benitez on 2/16/24.
//

import UIKit
import CoreData

protocol PresentUndoOption: AnyObject {
    func showUndoAlertController(for note: Note)
}

class NothingViewController: UIViewController {
    var collectionView: UICollectionView!
    var nothingLayout: UICollectionViewLayout!
    private let dynamicBarOffset: CGFloat = 60
    private let regularBarOffset: CGFloat = 25
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        nothingLayout = NothingCollectionViewLayout.collectionLayout()
        collectionView = NothingCollectionView(frame: view.frame, collectionViewLayout: nothingLayout)
        if let nothing = collectionView as? NothingCollectionView {
            nothing.undoDelegate = self
        }
        view.addSubview(collectionView)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if (traitCollection.userInterfaceIdiom == .pad) {
            view.bounds = view.frame.offsetBy(dx: 0, dy: -regularBarOffset)
        } else if ((traitCollection.userInterfaceIdiom == .phone) && (view.bounds.height > view.bounds.width)) {
            view.bounds = view.frame.offsetBy(dx: 0, dy: -dynamicBarOffset)
        } else {
            view.bounds = view.frame.offsetBy(dx: 0, dy: -regularBarOffset)
        }
    }
    
    private func presentUndoButton(for note: Note) -> UIAlertController {
        let alert = UIAlertController(title: "Delete note?", message: "Select Delete to remove or Undo to recover", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Delete", style: .destructive) { [unowned self] _ in
            if let nothing = self.collectionView as? NothingCollectionView {
                nothing.undoNoteCancelled(note)
            }
        }
        let undo = UIAlertAction(title: "Undo", style: .default) { [unowned self] _ in
            if let nothing = self.collectionView as? NothingCollectionView {
                nothing.undoNoteDeletion(note)
            }
        }
        alert.addAction(cancel)
        alert.addAction(undo)
        return alert
    }
}

extension NothingViewController: PresentUndoOption {
    func showUndoAlertController(for note: Note) {
        present(presentUndoButton(for: note), animated: true)
    }
}

