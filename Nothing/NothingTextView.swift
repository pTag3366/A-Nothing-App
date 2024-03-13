//
//  CustomView.swift
//  Nothing
//
//  Created by Jose Benitez on 2/16/24.
//

import UIKit

class NothingTextView: UITextView, UITextViewDelegate {
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        delegate = self
        accessibilityLabel = "NothingTextView"
        configure()
        
    }
    
    deinit {
        
    }
    
    @objc func handleKeyboardDidShow() {
//        print("keyboardNotificationDidShow")
    }
    
    private func configure() {
        backgroundColor = .clear
        adjustsFontForContentSizeCategory = true
        font = UIFont.preferredFont(forTextStyle: .title3)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPlaceholderText(with string: String) {
        text = string.components(separatedBy: ",").joined()
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
//        print("textViewDidBeginEditing !")
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return textView.isFirstResponder
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
//        print("textViewDidEndEditing !")
    }

}
