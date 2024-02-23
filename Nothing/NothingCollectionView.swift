//
//  CollectionView.swift
//  Nothing
//
//  Created by Jose Benitez on 2/20/24.
//

import UIKit

class NothingCollectionView: UICollectionView {
    
    static let sectionHeader = "SectionHeader"
    static let sectionFooter = "SectionFooter"
    
 
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        dataSource = self
        delegate = self
        register(NothingCollectionViewCell.self, forCellWithReuseIdentifier: NothingCollectionViewCell.collectionViewCellId)
        register(NothingCollectionViewReusableView.self, forSupplementaryViewOfKind: NothingCollectionView.sectionHeader, withReuseIdentifier: NothingCollectionView.sectionHeader)
        register(NothingCollectionViewReusableView.self, forSupplementaryViewOfKind: NothingCollectionView.sectionFooter, withReuseIdentifier: NothingCollectionView.sectionFooter)
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    
    
    class func collectionLayout() -> UICollectionViewLayout {
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
                                               heightDimension: .fractionalHeight(0.2)),
            elementKind: NothingCollectionView.sectionHeader,
            alignment: .top)
        let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.2)),
            elementKind: NothingCollectionView.sectionFooter,
            alignment: .bottom)
        
        sectionHeader.pinToVisibleBounds = true
        sectionHeader.zIndex = 2
        section.boundarySupplementaryItems = [sectionHeader, sectionFooter]
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
}

extension NothingCollectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: kind == NothingCollectionView.sectionHeader ? NothingCollectionView.sectionHeader : NothingCollectionView.sectionFooter,
                                                                                withReuseIdentifier: kind == NothingCollectionView.sectionHeader ? NothingCollectionView.sectionHeader : NothingCollectionView.sectionFooter,
                                                                                      for: indexPath) as? NothingCollectionViewReusableView 
        else { return UICollectionReusableView() }
        supplementaryView.label.text = kind == NothingCollectionView.sectionHeader ? NothingCollectionView.sectionHeader : NothingCollectionView.sectionFooter
        
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
        cell.label.text = indexPath.row.description + indexPath.section.description
        
        return cell
    }
    
    
}

extension NothingCollectionView: UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NothingCollectionViewCell.collectionViewCellId, for: indexPath)
        print(cell.reuseIdentifier!, indexPath.row, indexPath.section)
    }
}