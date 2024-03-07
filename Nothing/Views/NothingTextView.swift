//
//  CustomView.swift
//  Nothing
//
//  Created by Jose Benitez on 2/16/24.
//

import UIKit

class NothingTextView: UITextView, UITextViewDelegate {
    
//    let notificationManager = NothingNotificationManager()
//    var keyboardChangeObserver: NSObjectProtocol?
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        delegate = self
        accessibilityLabel = "NothingTextView"
        configure()
        
        
        //A one time only notification
//        let center = NotificationCenter.default
//        let mainQueue = OperationQueue.main
//        token = center.addObserver(
//            forName: NSNotification.Name("OneTimeNotification"),
//            object: nil,
//            queue: mainQueue) {[weak self] (note) in
//                print("Received the notification!")
//                guard let token = self?.token else { return }
//                center.removeObserver(token)
//        }
//        notificationManager.addKeyboardEventsObserver(self)
    }
    
    deinit {
        
    }
    
    @objc func handleKeyboardDidShow() {
        print("keyboardNotificationDidShow")
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
        text = string
    }
    
//    override func becomeFirstResponder() -> Bool {
//        
//        return super.becomeFirstResponder()
//    }
//    
//    override func resignFirstResponder() -> Bool {
//        
//        return super.resignFirstResponder()
//    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("textViewDidBeginEditing !")
        
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return textView.isFirstResponder
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print("textViewDidEndEditing !")
    }

}

//extension NothingCollectionView {
//    
//    @objc func willDisplayKeyboard() {
////        scrollRectToVisible(spaceForKeyboard, animated: true)
//        
////        print(keyboardLayoutGuide.owningView?.center)
//        print("willDisplayKeyboard!")
//    }
//    
//    @objc func willHideKeyboard() {
////        print(keyboardLayoutGuide.owningView?.center)
//        print("willHideKeyboard")
//    }
//}
