//
//  CollectionView.swift
//  Nothing
//
//  Created by Jose Benitez on 2/20/24.
//

import UIKit

class NothingCollectionView: UICollectionView {
    
//    var notificationCenter: NothingNotificationManager!
    let textViewdWillResign = Notification.Name("textViewWillResign")
    var spaceForKeyboard: CGRect {
//        CGRect(x: frame.minX, y: frame.minY + (frame.height * 0.1), width: frame.width, height: frame.height)
        frame.offsetBy(dx: 0, dy: frame.height / 2)
    }
    
    var keyboardChangeObserver: NSObjectProtocol!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        dataSource = self
        delegate = self
        register(NothingCollectionViewCell.self,
                 forCellWithReuseIdentifier: NothingCollectionViewCell.nothingCollectionViewCellId)
        register(NothingCollectionViewReusableView.self,
                 forSupplementaryViewOfKind: NothingCollectionViewReusableView.sectionHeader,
                 withReuseIdentifier: NothingCollectionViewReusableView.sectionHeader)
        register(NothingCollectionViewReusableView.self,
                 forSupplementaryViewOfKind: NothingCollectionViewReusableView.sectionFooter,
                 withReuseIdentifier: NothingCollectionViewReusableView.sectionFooter)
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        accessibilityLabel = "NothingCollectionView"
        NotificationCenter.default.addObserver(self, selector: #selector(NothingCollectionView.didShowKeyboard(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(NothingCollectionView.textViewWillResign(_:)), name: textViewdWillResign, object: nil)
//        notificationCenter.addKeyboardEventsObserver(self)
//        let notificationCenter = NotificationCenter.default
//        let mainQueue = OperationQueue.main
//        keyboardChangeObserver = notificationCenter.addObserver(
//            forName: UIResponder.keyboardDidShowNotification,
//            object: nil,
//            queue: mainQueue) { (notification) in
//                guard let userInfo = notification.userInfo else { return }
//
//                print(userInfo)
//
//                // In iOS 16.1 and later, the keyboard notification object is the screen the keyboard appears on.
//                guard let screen = notification.object as? UIScreen,
//                      // Get the keyboard’s frame at the end of its animation.
//                      let keyboardFrameEnd = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
//
//
//                // Use that screen to get the coordinate space to convert from.
//                let fromCoordinateSpace = screen.coordinateSpace
//            }
//        let center = NotificationCenter.default
//        guard let keyboardChangeObserver = self.keyboardChangeObserver else { return }
//        notificationCenter.removeObserver(keyboardChangeObserver)
//        let notificationCenterObject = NotificationCenter()
//        notificationCenter = NothingNotificationManager(notificationCenter: notificationCenterObject)
//        notificationCenter = NothingNotificationManager()
//        notificationCenter.addKeyboardEventsObserver(self)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension NothingCollectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: NothingCollectionViewReusableView.sectionHeader,
                                                                                      withReuseIdentifier: NothingCollectionViewReusableView.sectionHeader,
                                                                                      for: indexPath) as? NothingCollectionViewReusableView
        else { return UICollectionReusableView() }
        supplementaryView.label.text = NothingCollectionViewReusableView.sectionHeader
        
        return supplementaryView
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NothingCollectionViewCell.nothingCollectionViewCellId, for: indexPath) as? NothingCollectionViewCell
        {
            let placeholder = indexPath.row.description + indexPath.section.description
            cell.textView.setPlaceholderText(with: placeholder)
            cell.setAccessibilityLabel(with: placeholder)
            return cell
        }
        else {
            return UICollectionViewCell()
        }
    }
    
    
}

extension NothingCollectionView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NothingCollectionViewCell.nothingCollectionViewCellId, for: indexPath) as? NothingCollectionViewCell else { return }
//        _ = cell.textView.resignFirstResponder()
        //textDidEndEditingNotification
        //textDidEndEditingNotification
        NotificationCenter.default.post(name: textViewdWillResign, object: nil, userInfo: nil)
        print(cell.reuseIdentifier!, indexPath.row, indexPath.section)
//        scrollRectToVisible(spaceForKeyboard, animated: true)
    }
}

extension NothingCollectionView {
    
    @objc func textViewWillResign(_ notification: Notification) {
        print("textViewWillResign")
        endEditing(true)
    }
    
    @objc func willDisplayKeyboard(_ notification: Notification) {
        let userInfo = notification.userInfo
        print(userInfo as Any)
//        scrollRectToVisible(spaceForKeyboard, animated: true)
        
//        print(keyboardLayoutGuide.owningView?.center)
        print("willDisplayKeyboard!")
    }
    
    @objc func didShowKeyboard(_ notification: Notification) {
        let userInfo = notification.userInfo
        print(userInfo as Any)
        
        print("didShowKeyboard!")
//        notificationCenter.removeObserverObjects()
    }
    
    @objc func willHideKeyboard(_ notification: Notification) {
//        print(keyboardLayoutGuide.owningView?.center)
        print("willHideKeyboard")
    }
    
    @objc func didHideKeyboard(_ notification: Notification) {
        print("didHideKeyboard")
    }
}
