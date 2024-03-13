//
//  ViewController.swift
//  Nothing
//
//  Created by Jose Benitez on 2/16/24.
//

import UIKit

class NothingViewController: UIViewController {

    var collectionView: UICollectionView!
    var nothingLayout: UICollectionViewLayout!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        
        nothingLayout = NothingCollectionViewLayout.collectionLayout()
        collectionView = NothingCollectionView(frame: view.frame, collectionViewLayout: nothingLayout)
        view.addSubview(collectionView)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews() // A place to handle device orientation changes
        
    }
}

