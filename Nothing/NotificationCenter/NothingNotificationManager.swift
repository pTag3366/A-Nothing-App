//
//  NothingNotificationManager.swift
//  Nothing
//
//  Created by Jose Benitez on 3/5/24.
//

import UIKit

class NothingNotificationManager {
    
    private let collectionViewCellSwipeLeftToDelete = Notification.Name("collectionViewCellSwipeLeftToDelete")
    private let collectionViewCellDoubleTap = Notification.Name("collectionViewCellDoubleTap")
    private let textViewDidEndEditing = UITextView.textDidEndEditingNotification
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
        notificationCenter.addObserver(anObserver, selector: #selector(NothingCollectionView.didShowKeyboard(_:)), name: keyboardDidShow, object: nil)
        notificationCenter.addObserver(anObserver, selector: #selector(NothingCollectionView.textViewDidEndEditingText(_:)), name: textViewDidEndEditing, object: nil)
        notificationCenter.addObserver(anObserver, selector: #selector(NothingCollectionView.deleteNote(_:)), name: collectionViewCellSwipeLeftToDelete, object: nil)
        notificationCenter.addObserver(anObserver, selector: #selector(NothingCollectionView.scrollToLast), name: collectionViewCellDoubleTap, object: nil)
    }
    
    func postDeleteNoteGestureNotification(_ info: [AnyHashable: Any]?, object: Any?) {
        notificationCenter.post(name: collectionViewCellSwipeLeftToDelete, object: object, userInfo: info)
    }
    
    func postDoubleTapGestureNotification(_ info: [AnyHashable: Any]?, object: Any?) {
        notificationCenter.post(name: collectionViewCellDoubleTap, object: object, userInfo: info)
    }
}
