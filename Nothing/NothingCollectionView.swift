//
//  CollectionView.swift
//  Nothing
//
//  Created by Jose Benitez on 2/20/24.
//

import UIKit

class NothingCollectionView: UICollectionView {
    
    let textViewWillResignFirstResponder = Notification.Name("textViewWillResign")
    var totalNumberOfItems: Int = 0

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
//        NotificationCenter.default.addObserver(self, selector: #selector(NothingCollectionView.willDisplayKeyboard(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(NothingCollectionView.didShowKeyboard(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(NothingCollectionView.textViewWillResign(_:)), name: textViewWillResignFirstResponder, object: nil)
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
        return 10/*Int.random(in: 0...10)*/
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let itemsInSection = Int.random(in: 0...10)
        totalNumberOfItems += itemsInSection
        return 10/*itemsInSection*/
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NothingCollectionViewCell.nothingCollectionViewCellId, for: indexPath) as? NothingCollectionViewCell
        {
            
            let placeholder = indexPath.commaSeparatedStringRepresentation
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
        guard let _ = collectionView.dequeueReusableCell(withReuseIdentifier: NothingCollectionViewCell.nothingCollectionViewCellId, for: indexPath) as? NothingCollectionViewCell else { return }

        NotificationCenter.default.post(name: textViewWillResignFirstResponder, object: nil, userInfo: nil)
    }
}

extension NothingCollectionView {
    @objc func textViewWillResign(_ notification: Notification) {
        endEditing(true)
    }
    
    @objc func willDisplayKeyboard(_ notification: Notification) {
    }
    
    @objc func didShowKeyboard(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }

        // In iOS 16.1 and later, the keyboard notification object is the screen the keyboard appears on.
        guard let screen = notification.object as? UIScreen,
              // Get the keyboard’s frame at the end of its animation.
              let keyboardFrameEnd = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        // Use that screen to get the coordinate space to convert from.
        let _ = screen.coordinateSpace

        let visibleCellOnScreen = visibleCells.compactMap { $0 as? NothingCollectionViewCell }
        let isCellSelected = visibleCellOnScreen.first(where: { $0.textView.isFirstResponder })!
                
        scrollRectToVisible(isCellSelected.frame, animated: true)
    }
    
    @objc func willHideKeyboard(_ notification: Notification) {

    }
    
    @objc func didHideKeyboard(_ notification: Notification) {

    }
    
    private func adjustForKeyboard(_ rect: CGRect) {
        
    }
}
