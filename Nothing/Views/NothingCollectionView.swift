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
        
        // Use that screen to get the coordinate space to convert from.
        let fromCoordinateSpace = screen.coordinateSpace


        // Get your view's coordinate space.
        let toCoordinateSpace: UICoordinateSpace = super.coordinateSpace


        // Convert the keyboard's frame from the screen's coordinate space to your view's coordinate space.
        let convertedKeyboardFrameEnd = fromCoordinateSpace.convert(keyboardFrameEnd, to: toCoordinateSpace)
        
        // Get the safe area insets when the keyboard is offscreen.
        var bottomOffset = self.safeAreaInsets.bottom
            
        // Get the intersection between the keyboard's frame and the view's bounds to work with the
        // part of the keyboard that overlaps your view.
        let viewIntersection = self.bounds.intersection(convertedKeyboardFrameEnd)
            
        // Check whether the keyboard intersects your view before adjusting your offset.
        if !viewIntersection.isEmpty {
                
            // Adjust the offset by the difference between the view's height and the height of the
            // intersection rectangle.
            bottomOffset = self.bounds.maxY - viewIntersection.minY
        }
        
        let currentFrame = CGRect(x: 0, y: self.bounds.maxY - self.bounds.height, width: self.bounds.width, height: self.frame.height)
        let fullCellHeigthFromMaxYBounds = currentFrame.minY + self.bounds.height
        var distance = self.bounds.height - fullCellHeigthFromMaxYBounds
//        visibleCells.forEach {
//            let intersection = $0.frame.intersection(currentFrame)
//            print(intersection)
//        }
        let allVisibleCells = returnAllSubviews(type: NothingCollectionViewCell.self)
//        self.subviews.forEach {
//            print($0.self, $0.frame.intersects(currentFrame), $0.frame.intersection(currentFrame))
//        }
        var intersects = [CGRect]()
        allVisibleCells.forEach {
            if ($0.frame.intersects(currentFrame) == true) {
                intersects.append($0.frame)
            }
//            print($0.self, $0.frame.intersects(currentFrame), $0.frame.intersection(currentFrame))
        }
        
        let focusRect = intersects.max(by: { a, b in a.size > b.size }) ?? .zero/*visibleCells.map { $0.frame.intersection(self.bounds) }.max(by: { a, b in a.height > b.height }) ?? .zero*/
        distance = distance + focusRect.origin.y
        
        scrollRectToVisible(currentFrame.offsetBy(dx: 0, dy: distance), animated: true)
        
        // Use the new offset to adjust your UI, for example by changing a layout guide, offsetting
        // your view, changing a scroll inset, and so on. This example uses the new offset to update
        // the value of an existing Auto Layout constraint on the view.
//        movingBottomConstraint.constant = bottomOffset
    }
    
    @objc func willHideKeyboard(_ notification: Notification) {

    }
    
    @objc func didHideKeyboard(_ notification: Notification) {

    }
    
    private func adjustForKeyboard(_ rect: CGRect) {
        
    }
}

extension UICollectionView {
    
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
