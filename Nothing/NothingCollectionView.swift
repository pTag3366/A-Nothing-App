//
//  CollectionView.swift
//  Nothing
//
//  Created by Jose Benitez on 2/20/24.
//

import UIKit

class NothingCollectionViewTransitionLayout: UICollectionViewTransitionLayout {
    
    override init(currentLayout: UICollectionViewLayout, nextLayout newLayout: UICollectionViewLayout) {
        super.init(currentLayout: currentLayout, nextLayout: newLayout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    class func landscapeCollectionLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.8))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.1)),
            elementKind: NothingCollectionView.sectionHeader,
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
            elementKind: NothingCollectionView.sectionHeader,
            alignment: .top)

        sectionHeader.zIndex = 2
        section.boundarySupplementaryItems = [sectionHeader]
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    
    
}

class NothingCollectionView: UICollectionView {
    
    static let sectionHeader = "SectionHeader"
    static let sectionFooter = "SectionFooter"
    var isPortraitLayout: Bool = true
    
 
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        dataSource = self
        delegate = self
        register(NothingCollectionViewCell.self, 
                 forCellWithReuseIdentifier: NothingCollectionViewCell.collectionViewCellId)
        register(NothingCollectionViewReusableView.self,
                 forSupplementaryViewOfKind: NothingCollectionView.sectionHeader,
                 withReuseIdentifier: NothingCollectionView.sectionHeader)
        register(NothingCollectionViewReusableView.self,
                 forSupplementaryViewOfKind: NothingCollectionView.sectionFooter,
                 withReuseIdentifier: NothingCollectionView.sectionFooter)
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
}

extension NothingCollectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: NothingCollectionView.sectionHeader, 
                                                                                      withReuseIdentifier: NothingCollectionView.sectionHeader,
                                                                                      for: indexPath) as? NothingCollectionViewReusableView
        else { return UICollectionReusableView() }
        supplementaryView.label.text = NothingCollectionView.sectionHeader
        
        return supplementaryView
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NothingCollectionViewCell.collectionViewCellId, for: indexPath) as? NothingCollectionViewCell
        else { return UICollectionViewCell() }
        cell.textField.placeholder = indexPath.row.description + indexPath.section.description
        
        return cell
    }
    
    
}

extension NothingCollectionView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, transitionLayoutForOldLayout fromLayout: UICollectionViewLayout, newLayout toLayout: UICollectionViewLayout) -> UICollectionViewTransitionLayout {
        
        return NothingCollectionViewTransitionLayout(currentLayout: fromLayout, nextLayout: toLayout)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NothingCollectionViewCell.collectionViewCellId, for: indexPath)
        print(cell.reuseIdentifier!, indexPath.row, indexPath.section)
        if (!collectionView.hasAmbiguousLayout && isPortraitLayout) {
            collectionView.collectionViewLayout = NothingCollectionViewTransitionLayout.landscapeCollectionLayout()
            isPortraitLayout = false
            
        } else if (!collectionView.hasAmbiguousLayout && !isPortraitLayout) {
            collectionView.collectionViewLayout = NothingCollectionViewTransitionLayout.portraitCollectionLayout()
            isPortraitLayout = true
        }
        if let nothingCell = cell as? NothingCollectionViewCell {
//            nothingCell.textField.setNeedsDisplay(nothingCell.bounds)
            nothingCell.setNeedsLayout()
        }
    }
    
    override func startInteractiveTransition(to layout: UICollectionViewLayout, completion: UICollectionView.LayoutInteractiveTransitionCompletion? = nil) -> UICollectionViewTransitionLayout {
        print("layout transition started")
        let layout = NothingCollectionViewTransitionLayout(currentLayout: NothingCollectionViewTransitionLayout.portraitCollectionLayout(), nextLayout: NothingCollectionViewTransitionLayout.landscapeCollectionLayout())
        
        return layout
    }
}
