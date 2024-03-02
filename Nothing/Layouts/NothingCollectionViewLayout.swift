//
//  NothingCollectionViewLayout.swift
//  Nothing
//
//  Created by Jose Benitez on 2/27/24.
//

import UIKit

class NothingCollectionViewLayout: UICollectionViewLayout {
    
    var rect: CGRect = .zero
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        super.init()
//        register(NothingCollectionViewReusableView.self, forDecorationViewOfKind: NothingCollectionViewReusableView.sectionHeader)
    }
    
    convenience init(rect: CGRect) {
        self.init()
        self.rect = rect
    }
    
//    override var collectionViewContentSize: CGSize {
//        return collectionView?.contentSize ?? CGSize.zero
//    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        print(rect)
//        if (elementKind.elementsEqual(NothingCollectionViewReusableView.sectionHeader)) {
//            let attributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(row: 0, section: 0))
//            attributes.frame = CGRect(x: 0, y: 0, width: 393 * 1.0, height: 852 * 0.1)
//
//        }
        var attributes = [UICollectionViewLayoutAttributes]()
        let attribute1 = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: NothingCollectionViewReusableView.sectionHeader, with: IndexPath(row: 0, section: 0))
        let attribute2 = UICollectionViewLayoutAttributes(forCellWith: IndexPath(row: 0, section: 0))
        attributes.append(attribute1)
        attributes.append(attribute2)
        
//        attributes.append()
//        attributes.append(UICollectionViewLayoutAttributes(forCellWith: IndexPath(row: 0, section: 0))) = /*CGRect(x: 0, y: 0, width: 393 * 0.8, height: 852 * 0.36901)*/
        
        return attributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        print(rect)
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.frame = CGRect(x: 0, y: 0, width: 393 * 0.8, height: 852 * 0.36901)
        
        return attributes
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if (elementKind.elementsEqual(NothingCollectionViewReusableView.sectionHeader)) {
            let attributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(row: 0, section: 0))
            attributes.frame = CGRect(x: 0, y: 0, width: 393 * 1.0, height: 852 * 0.1)

        }
        return nil
    }
    
//    override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        
//    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return false
    }
    
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(row: 0, section: 0))
        attributes.frame = CGRect(x: 0, y: 0, width: 393 * 0.8, height: 852 * 0.36901)
        return attributes
    }
    
    override func initialLayoutAttributesForAppearingSupplementaryElement(ofKind elementKind: String, at elementIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return nil
    }
    
    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(row: 0, section: 0))
        attributes.frame = CGRect(x: 0, y: 0, width: 393 * 0.8, height: 852 * 0.36901)
        return attributes
    }
    
    override func finalLayoutAttributesForDisappearingSupplementaryElement(ofKind elementKind: String, at elementIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return nil
    }
    
//    override func finalLayoutAttributesForDisappearingDecorationElement(ofKind elementKind: String, at decorationIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        
//    }
    
    
    /// class functions to layout  collection view items with compositional layout
    class func landscapeCollectionLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.1)),
            elementKind: NothingCollectionViewReusableView.sectionHeader,
            alignment: .top)
        
        sectionHeader.zIndex = 2
        section.boundarySupplementaryItems = [sectionHeader]
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    class func portraitCollectionLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.4))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.1)),
            elementKind: NothingCollectionViewReusableView.sectionHeader,
            alignment: .top)
        
        sectionHeader.zIndex = 2
        section.boundarySupplementaryItems = [sectionHeader]
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
}
