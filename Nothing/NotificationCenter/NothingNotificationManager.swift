//
//  NothingNotificationManager.swift
//  Nothing
//
//  Created by Jose Benitez on 3/5/24.
//

import UIKit

class NothingNotificationManager {
    
    private let textViewWillResignFirstResponder = Notification.Name("textViewWillResign")
    private let textViewWillSaveChanges = Notification.Name("textViewWillSaveChanges")
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
    
    func addKeyboardEventsObserver(_ anObserver: Any) {
        observers.append(anObserver)
        notificationCenter.addObserver(anObserver, selector: #selector(NothingCollectionView.didShowKeyboard(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        notificationCenter.addObserver(anObserver, selector: #selector(NothingCollectionView.textViewWillResignEditing(_:)), name: textViewWillResignFirstResponder, object: nil)
        notificationCenter.addObserver(anObserver, selector: #selector(NothingCollectionView.saveChanges(_:)), name: textViewWillSaveChanges, object: nil)
    }
    
    func postTextViewWillResignNotification() {
        notificationCenter.post(name: textViewWillResignFirstResponder, object: nil, userInfo: nil)
    }
    
    func postTextViewWillSaveChangesNotification(_ text: String) {
        var info = [AnyHashable: Any]()
        info.updateValue(text, forKey: "text")
        notificationCenter.post(name: textViewWillSaveChanges, object: nil, userInfo: info)
    }
}
