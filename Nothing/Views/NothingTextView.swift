//
//  CustomView.swift
//  Nothing
//
//  Created by Jose Benitez on 2/16/24.
//

import UIKit

class NothingTextView: UITextView {
    
    private let notifications: NothingNotificationManager = NothingNotificationManager(notificationCenter: .default)
    private(set) var indexPath: IndexPath? = nil
    
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
    
    func setNoteText(for note: Note) {
        guard let textData = note.textData, let textString = String(data: textData, encoding: .utf8),
        let _ = note.uuid, let _ = note.url, let _ = note.dateCreated, let _ = note.lastModified,
        indexPath != IndexPath(item: 0, section: 0)
        else {
            text = ""
            return }
        text = "\(textString)"
    }
}

extension NothingTextView:  UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return textView.isFirstResponder
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
    }
}
