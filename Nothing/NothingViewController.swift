//
//  ViewController.swift
//  Nothing
//
//  Created by Jose Benitez on 2/16/24.
//

import UIKit

class NothingViewController: UIViewController {

    var collectionView: UICollectionView!
    var container: UIViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        collectionView = NothingCollectionView(frame: view.bounds,
                                               collectionViewLayout: NothingCollectionView.collectionLayout())
        container = UIViewController()
        
        container.view.backgroundColor = .cyan
        
        container.view.addSubview(collectionView)
        
        addChild(container)
        
        container.view.frame = view.frame
        view.addSubview(container.view)
        
        container.didMove(toParent: self)
//        view.addSubview(collectionView)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
//            self.willMove(toParent: nil)
//            self.view.removeFromSuperview()
//            self.removeFromParent()
//            
//        }
//        collectionView.setNeedsDisplay()
//        print("viewDidAppear")
//        print("CollectionViewCell bounds: ", collectionView.visibleCells[0].contentView.bounds)
    }
}

