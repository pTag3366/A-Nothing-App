//
//  CustomView.swift
//  Nothing
//
//  Created by Jose Benitez on 2/16/24.
//

import UIKit

class NothingTextField: UITextField, UITextFieldDelegate {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        delegate = self
        backgroundColor = .lightGray
        addPinchAwayGestureRecognizer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func pinchAwayGesture() {
        print("Gesture recognized !")
        becomeFirstResponder()
//        print("resigned first responder !")
    }
    
    func addPinchAwayGestureRecognizer() {
//        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.pinchAwayGesture))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.pinchAwayGesture))
        addGestureRecognizer(tapGesture)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("textfieldShouldBeginEditing !")
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("textFieldDidBeginEditing !")
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print("textFieldShouldEndEditing !")
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("textFieldDidEndEditing !")
    }
    
    
}
