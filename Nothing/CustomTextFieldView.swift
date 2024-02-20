//
//  CustomView.swift
//  Nothing
//
//  Created by Jose Benitez on 2/16/24.
//

import UIKit

class CustomTextFieldView: UITextField, UITextFieldDelegate {
    
//    var textRect: CGRect = .zero
//    var placeholderRect: CGRect = .zero
//    var drawingRect: CGRect = .zero
//    var borderRect: CGRect = .zero
//    var editRect: CGRect = .zero
//    var clearRect: CGRect = .zero
//    var leftRect: CGRect = .zero
//    var rightRect: CGRect = .zero
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        delegate = self
        backgroundColor = .lightGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func textRect(forBounds bounds: CGRect) -> CGRect { // *****
//        textRect = CGRect(x: 100, y: 100, width: 200, height: 200)
//        return textRect
//    }
//    
//    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
////        placeholderRect = CGRect(x: 0, y: 0, width: 200, height: 200)
//        return placeholderRect
//    }
//    
//    override func drawPlaceholder(in rect: CGRect) {
//        
//    }
//    
//    override func borderRect(forBounds bounds: CGRect) -> CGRect {
//        return borderRect
//    }
//    
//    override func editingRect(forBounds bounds: CGRect) -> CGRect { // *****
//        editRect = CGRect(x: 100, y: 100, width: 200, height: 200)
//        return editRect
//    }
//    
//    override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
//        return clearRect
//    }
//    
//    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
//        return leftRect
//    }
//    
//    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
//        return rightRect
//    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("textfieldShouldBeginEditing!!!")
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("textFieldDidBeginEditing!!!")
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print("textFieldShouldEndEditing!!!")
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("textFieldDidEndEditing!!!")
    }
}


/*
 
 //    var centerXConstraint: NSLayoutConstraint?
 //    var centerYConstraint: NSLayoutConstraint?
 //    var leadingConstraint: NSLayoutConstraint?
 //    var trailingConstraint: NSLayoutConstraint?
 //    var bottomConstraint: NSLayoutConstraint?
 //    var topConstraint: NSLayoutConstraint?
     
 //    lazy var textField: UITextField = {
 //        let view = UITextField()
 //        view.translatesAutoresizingMaskIntoConstraints = false
 //        view.backgroundColor = .lightGray
 //        return view
 //    }()
 
//    func activateConstraints() {
//        var leadingConstraint: NSLayoutConstraint?
//        var trailingConstraint: NSLayoutConstraint?
//        var bottomConstraint: NSLayoutConstraint?
//        var topConstraint: NSLayoutConstraint?
//        leadingConstraint = NSLayoutConstraint(item: self,
//                                               attribute: .leading,
//                                               relatedBy: .lessThanOrEqual,
//                                               toItem: safeAreaLayoutGuide,
//                                               attribute: .leading,
//                                               multiplier: 1,
//                                               constant: 0)
//        trailingConstraint = NSLayoutConstraint(item: self,
//                                                attribute: .trailing,
//                                                relatedBy: .lessThanOrEqual,
//                                                toItem: safeAreaLayoutGuide,
//                                                attribute: .trailing,
//                                                multiplier: 1,
//                                                constant: 0)
//        bottomConstraint = NSLayoutConstraint(item: self,
//                                              attribute: .bottom,
//                                              relatedBy: .lessThanOrEqual,
//                                              toItem: safeAreaLayoutGuide,
//                                              attribute: .bottom,
//                                              multiplier: 1,
//                                              constant: 0)
//        topConstraint = NSLayoutConstraint(item: self,
//                                           attribute: .top,
//                                           relatedBy: .lessThanOrEqual,
//                                           toItem: safeAreaLayoutGuide,
//                                           attribute: .top,
//                                           multiplier: 1,
//                                           constant: 0)
//        let constraints: Array<NSLayoutConstraint> = [leadingConstraint, trailingConstraint, bottomConstraint, topConstraint].compactMap { $0 }
//        constraints.forEach { $0.isActive = true }
//        addConstraints(constraints)
//
//        //        centerXConstraint = NSLayoutConstraint(item: self,
//        //                                               attribute: .centerX,
//        //                                               relatedBy: .equal,
//        //                                               toItem: safeAreaLayoutGuide,
//        //                                               attribute: .centerX,
//        //                                               multiplier: 1,
//        //                                               constant: 0)
//        //        centerYConstraint = NSLayoutConstraint(item: self,
//        //                                               attribute: .centerY,
//        //                                               relatedBy: .equal,
//        //                                               toItem: safeAreaLayoutGuide,
//        //                                               attribute: .centerY,
//        //                                               multiplier: 1,
//        //                                               constant: 0)
//
//    }
 */
