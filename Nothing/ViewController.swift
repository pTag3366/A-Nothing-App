//
//  ViewController.swift
//  Nothing
//
//  Created by Jose Benitez on 2/16/24.
//

import UIKit

class ViewController: UIViewController {
    
    
    var widthConstraint: NSLayoutConstraint!
    var heightConstraint: NSLayoutConstraint!
    var centerXConstraint: NSLayoutConstraint!
    var centerYConstraint: NSLayoutConstraint!
    
    
    lazy var textField: CustomTextFieldView = {
        let rect: CGRect = CGRect.zero
        return CustomTextFieldView(frame: rect)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(textField)
        activateConstraints()
        addPinchAwayGestureRecognizer()
    }
    
    @objc func pinchAwayGesture() {
        print("Gesture recognized!!!")
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
            self.textField.resignFirstResponder()
        }) { _ in
//            UIView.ani
        }
          
//            self.textField.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1).isActive = false
//            self.textField.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1).isActive = false
//            self.textField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = false
//            self.textField.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = false
//            self.textField.layoutIfNeeded()
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

