//
//  ViewController.swift
//  Nothing
//
//  Created by Jose Benitez on 2/16/24.
//

import UIKit
import CoreData

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
}

