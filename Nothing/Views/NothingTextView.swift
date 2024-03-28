//
//  CustomView.swift
//  Nothing
//
//  Created by Jose Benitez on 2/16/24.
//

import UIKit

class NothingTextView: UITextView, UITextViewDelegate {
    
    private let notifications: NothingNotificationManager = NothingNotificationManager(notificationCenter: .default)
    private(set) var indexPath: IndexPath = IndexPath()
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        delegate = self
        accessibilityLabel = "NothingTextView"
        configure()
        
    }
    
    deinit {
        
    }
    
    private func configure() {
        backgroundColor = .clear
        adjustsFontForContentSizeCategory = true
        font = UIFont.preferredFont(forTextStyle: .title3)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setIndexPath(_ index: IndexPath) {
        indexPath = index
    }
    
    func setNoteText(with string: String) {
        text = string
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if let textString = textView.text, !textString.isEmpty {
//            var info = [AnyHashable: Any]()
//            info.updateValue(textString, forKey: "textString")
//            notifications.postTextViewDidBeginEditingNotification(info, object: nil)
        }
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return textView.isFirstResponder
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if let textString = textView.text, !textString.isEmpty {
            var info = [AnyHashable: Any]()
            info.updateValue(textString, forKey: "textString")
            info.updateValue(indexPath, forKey: "indexPath")
            notifications.postTextViewDidEndEditingNotification(info, object: nil)
        }
    }
}
