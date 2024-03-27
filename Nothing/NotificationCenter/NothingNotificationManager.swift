//
//  NothingNotificationManager.swift
//  Nothing
//
//  Created by Jose Benitez on 3/5/24.
//

import UIKit

class NothingNotificationManager {
    
    private let textViewWillResignFirstResponder = Notification.Name("textViewWillResign")
    private let textViewDidEndEditing = Notification.Name("textViewDidEndEditing")
    private let collectionViewCellPinchToDelete = Notification.Name("collectionViewCellPinchToDelete")
    private let notificationCenter: NotificationCenter
    private let keyboardDidShow = UIResponder.keyboardDidShowNotification
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
}
