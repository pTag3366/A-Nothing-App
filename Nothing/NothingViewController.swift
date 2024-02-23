//
//  ViewController.swift
//  Nothing
//
//  Created by Jose Benitez on 2/16/24.
//

import UIKit

class NothingViewController: UIViewController {
    
    
    var widthConstraint: NSLayoutConstraint!
    var heightConstraint: NSLayoutConstraint!
    var centerXConstraint: NSLayoutConstraint!
    var centerYConstraint: NSLayoutConstraint!
    var collectionView: UICollectionView!
    
    lazy var textField: NothingTextFieldView = {
        let rect: CGRect = CGRect.zero
        return NothingTextFieldView(frame: rect)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView = NothingCollectionView(frame: view.bounds, 
                                               collectionViewLayout: NothingCollectionView.collectionLayout())
        view.addSubview(collectionView)
        // Do any additional setup after loading the view.
    }
    
    @objc func pinchAwayGesture() {
        print("Gesture recognized!!!")
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
            self.textField.resignFirstResponder()
        }) { _ in

        }
    }

    func addPinchAwayGestureRecognizer() {
        let gesture = UIPinchGestureRecognizer(target: self, action: #selector(self.pinchAwayGesture))
        view.addGestureRecognizer(gesture)
    }
    
    func activateConstraints() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1).isActive = true
        textField.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1).isActive = true
        textField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textField.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}

