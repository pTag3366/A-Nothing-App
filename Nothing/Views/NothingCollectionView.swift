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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NothingCollectionViewCell.nothingCollectionViewCellId, for: indexPath) as? NothingCollectionViewCell else { return }

        NotificationCenter.default.post(name: textViewWillResignFirstResponder, object: nil, userInfo: nil)
//        scrollRectToVisible(self.bounds, animated: true)
//        print(cell.frame)
//        print(totalNumberOfItems)

    }
}

extension NothingCollectionView {
    @objc func textViewWillResign(_ notification: Notification) {
        print("textViewWillResign")
        endEditing(true)
    }
    
    @objc func willDisplayKeyboard(_ notification: Notification) {
//        let userInfo = notification.userInfo
//        print(userInfo as Any)
    }
    
    @objc func didShowKeyboard(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }


        // In iOS 16.1 and later, the keyboard notification object is the screen the keyboard appears on.
        guard let screen = notification.object as? UIScreen,
              // Get the keyboard’s frame at the end of its animation.
              let keyboardFrameEnd = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let currentFrame = CGRect(x: 0, y: self.bounds.maxY - self.bounds.height, width: self.bounds.width, height: self.frame.height)
        
        // Use that screen to get the coordinate space to convert from.
        let fromCoordinateSpace = screen.coordinateSpace

//        var visibleCellOnScreen = NothingCollectionViewCell()
        let cellAtCenterIndexPath = indexPathForItem(at: CGPoint(x: self.bounds.midX, y: self.bounds.midY))
        let visibleCellOnScreen = visibleCells.compactMap { $0 as? NothingCollectionViewCell }
        let isCellSelected = visibleCellOnScreen.first(where: { $0.textView.isFirstResponder })!
        
        // Get your view's coordinate space.
//        let toCoordinateSpace: UICoordinateSpace = view


        // Convert the keyboard's frame from the screen's coordinate space to your view's coordinate space.
//        let convertedKeyboardFrameEnd = fromCoordinateSpace.convert(keyboardFrameEnd, to: toCoordinateSpace)
        
        
//        let offset = allVisibleIndexPaths.map({ expectedOffset(at: $0) })
//
//        var intersects: [CGRect] = [CGRect]()
//        intersects = allVisibleCells.map { $0.intersection(currentFrame) }
//        
//        let minIntersect = intersects.map({ $0.height }).min() ?? 0.0
//        let scrollValue = self.bounds.minY - minIntersect
        
//        distance = self.bounds.height - maxIntersect
                
        scrollRectToVisible(isCellSelected.frame, animated: true)
    }
    
    @objc func willHideKeyboard(_ notification: Notification) {

    }
    
    @objc func didHideKeyboard(_ notification: Notification) {

    }
    
    private func adjustForKeyboard(_ rect: CGRect) {
        
    }
}

extension UICollectionView {
    
    var expectedSectionHeight: CGFloat {
        return (self.bounds.height * 1/10) //collection view compositional layout dimensions
    }
    
    var expectedCellItemHeight: CGFloat {
        return (self.bounds.height * 4/5)    //collection view compositional layout dimensions
    }
    
    func expectedOffset(at indexPath: IndexPath) -> CGFloat {
        var offset: CGFloat = 0.0
        for _ in 0...indexPath.section {
            offset += expectedSectionHeight
            for _ in 0...indexPath.row {
                offset += expectedCellItemHeight
            }
        }
        return offset
    }
    
    var maxVisibleMinY: CGFloat {
        return visibleCells.map { $0.frame.minY }.max() ?? 0.0
    }
    
}

extension UIView {
    func returnAllSubviews<T: UIView>(type: T.Type) -> [T] {
        // base case: I am a UILabel
        // return myself
        var subLabels: [T] = []
        if let label = self as? T {
            subLabels.append(label)
        }
        // I have subviews, go check if any of those are labels
        for view in self.subviews {
            let labels = view.returnAllSubviews(type: T.self)
            subLabels.append(contentsOf: labels)
        }
        return subLabels
    }
}

extension CGSize: Comparable {
    public static func < (lhs: CGSize, rhs: CGSize) -> Bool {
        (lhs.width * lhs.height) < (rhs.width * rhs.height)
    }
    
    public static func > (lhs: CGSize, rhs: CGSize) -> Bool {
        (lhs.width * lhs.height) > (rhs.width * rhs.height)
    }
    
}
