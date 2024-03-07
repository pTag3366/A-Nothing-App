//
//  NothingNotificationManager.swift
//  Nothing
//
//  Created by Jose Benitez on 3/5/24.
//

import UIKit

class NothingNotificationManager {
    private let notificationCenter: NotificationCenter
    private let keyboardWillShow = UIResponder.keyboardWillShowNotification
    private let keyboardDidShow = UIResponder.keyboardDidShowNotification
    private let keyboardWillHide = UIResponder.keyboardWillHideNotification
    private let keyboardDidHide = UIResponder.keyboardDidHideNotification
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
        notificationCenter.addObserver(anObserver, selector: #selector(NothingCollectionView.willDisplayKeyboard(_:)), name: keyboardWillShow, object: nil)
        notificationCenter.addObserver(anObserver, selector: #selector(NothingCollectionView.didShowKeyboard(_:)), name: keyboardDidShow, object: nil)
//        notificationCenter.addObserver(observer, selector: #selector(NothingCollectionView.willDisplayKeyboard), name: keyboardWillShow, object: nil)
//        notificationCenter.addObserver(observer, selector: #selector(NothingCollectionView.willHideKeyboard), name: keyboardWillHide, object: nil)
//        notificationCenter.addObserver(forName: keyboardDidShow, object: observer, queue: .main) { notification in
//            guard let userInfo = notification.userInfo else { return }
//
//
//            // In iOS 16.1 and later, the keyboard notification object is the screen the keyboard appears on.
//            guard let screen = notification.object as? UIScreen,
//                  // Get the keyboard’s frame at the end of its animation.
//                  let keyboardFrameEnd = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
//
//
//            // Use that screen to get the coordinate space to convert from.
//            let fromCoordinateSpace = screen.coordinateSpace


            // Get your view's coordinate space.
//            let toCoordinateSpace: UICoordinateSpace = view


            // Convert the keyboard's frame from the screen's coordinate space to your view's coordinate space.
//            let convertedKeyboardFrameEnd = fromCoordinateSpace.convert(keyboardFrameEnd, to: toCoordinateSpace)
//        }
    }
    
    func postWillDisplayKeyboardNotification() {
//        notificationCenter.post(name: keyboardWillShow, object: nil)
//        let userInfo: [String: CGRect]
//        notificationCenter.post(name: keyboardWillShow, object: nil, userInfo: userInfo)
    }
    
    func postWillHideKeyboardNotification() {
//        notificationCenter.post(name: keyboardWillHide, object: nil)
    }
}
