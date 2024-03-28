//
//  NothingNotificationManager.swift
//  Nothing
//
//  Created by Jose Benitez on 3/5/24.
//

import UIKit

class NothingNotificationManager {
    
    private let textViewWillResignFirstResponder = Notification.Name("textViewWillResign")
    private let collectionViewCellPinchToDelete = Notification.Name("collectionViewCellPinchToDelete")
    private let textViewDidBeginEditing = UITextView.textDidBeginEditingNotification
    private let textViewDidEndEditing = UITextView.textDidEndEditingNotification
    private let textViewDidChangeText = UITextView.textDidChangeNotification
    private let keyboardDidShow = UIResponder.keyboardDidShowNotification
    private let notificationCenter: NotificationCenter
    private var observers: [Any] = []
    
    
    init(notificationCenter: NotificationCenter = .default) {
        self.notificationCenter = notificationCenter
        
    }
    
    deinit {
        removeObserverObjects()
    }
    
    func removeObserverObjects() {
        for observer in observers {
            notificationCenter.removeObserver(observer)
        }
    }
    
    func addEventsObserver(_ anObserver: Any) {
        observers.append(anObserver)
        notificationCenter.addObserver(anObserver, selector: #selector(NothingCollectionView.didShowKeyboard(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        notificationCenter.addObserver(anObserver, selector: #selector(NothingCollectionView.textViewWillResignEditing(_:)), name: textViewWillResignFirstResponder, object: nil)
        notificationCenter.addObserver(anObserver, selector: #selector(NothingCollectionView.textViewDidEndEditingText(_:)), name: textViewDidEndEditing, object: nil)
        notificationCenter.addObserver(anObserver, selector: #selector(NothingCollectionView.textViewDidBeginTextUpdates(_:)), name: textViewDidBeginEditing, object: nil)
//        notificationCenter.addObserver(anObserver, selector: #selector(NothingCollectionView.textViewDidBeginTextUpdates(_:)), name: textViewDidChangeText, object: nil)
        notificationCenter.addObserver(anObserver, selector: #selector(NothingCollectionView.deleteNote(_:)), name: collectionViewCellPinchToDelete, object: nil)
    }
    
    func postTextViewWillResignNotification(_ info: [AnyHashable: Any]?, object: Any?) {
        
        notificationCenter.post(name: textViewWillResignFirstResponder, object: object, userInfo: info)
    }
    
    func postTextViewDidEndEditingNotification(_ info: [AnyHashable: Any]?, object: Any?) {
        
        notificationCenter.post(name: textViewDidEndEditing, object: object, userInfo: info)
    }
    
    func postDeleteNoteGestureNotification(_ info: [AnyHashable: Any]?, object: Any?) {
        notificationCenter.post(name: collectionViewCellPinchToDelete, object: object, userInfo: info)
    }
    
    func postTextViewDidBeginEditingNotification(_ info: [AnyHashable: Any]?, object: Any?) {
        notificationCenter.post(name: textViewDidBeginEditing, object: object, userInfo: info)
    }
    
    func postTextViewDidChangeTextNotification(_ info: [AnyHashable: Any]?, object: Any?) {
        notificationCenter.post(name: textViewDidChangeText, object: object, userInfo: info)
    }
}
