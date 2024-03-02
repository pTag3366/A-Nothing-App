//
//  ViewController.swift
//  Nothing
//
//  Created by Jose Benitez on 2/16/24.
//

import UIKit

class NothingViewController: UIViewController {

    var collectionView: UICollectionView!
//    var container: UIViewController!
    var aspectRatio: CGFloat {
        return view.bounds.width / view.bounds.height
    }
    var sizeOfView: CGRect {
        get {
            guard let collectionView = collectionView else { return .zero }
            return CGRect(x: collectionView.frame.minX, y: collectionView.frame.minY, width: collectionView.bounds.width * 0.8, height: collectionView.bounds.height * 0.36901) }
    }
    var nothingLayout: UICollectionViewLayout!/*NothingCollectionViewLayout!*/

    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
//        let size = CGSize(width: view.bounds.width * 0.8, height: view.bounds.height * 0.36901)
        
//        collectionView = NothingCollectionView(frame: view.frame,
//                                               collectionViewLayout: NothingCollectionViewLayout.portraitCollectionLayout(with: sizeOfView.size))
//        
//        nothingLayout = NothingCollectionViewLayout()
        nothingLayout = NothingCollectionViewLayout.portraitCollectionLayout()
        collectionView = NothingCollectionView(frame: view.frame, collectionViewLayout: nothingLayout)
        view.addSubview(collectionView)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews() // A place to handle device orientation changes
//        print("aspectRatio: ", aspectRatio)
        print(sizeOfView.size)
//        collectionView.collectionViewLayout = NothingCollectionViewLayout.portraitCollectionLayout(with: sizeOfView.size)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
//            self.willMove(toParent: nil)
//            self.view.removeFromSuperview()
//            self.removeFromParent()
//            
//        }
    }
}

