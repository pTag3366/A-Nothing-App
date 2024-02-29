//
//  CollectionView.swift
//  Nothing
//
//  Created by Jose Benitez on 2/20/24.
//

import UIKit

class NothingCollectionView: UICollectionView {
    
    var isPortraitLayout: Bool = true
 
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
            cell.textView.text = indexPath.row.description + indexPath.section.description
            cell.accessibilityLabel = (cell.accessibilityLabel ?? "") + indexPath.row.description + indexPath.section.description
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
        print(cell.reuseIdentifier!, indexPath.row, indexPath.section)
        if (!collectionView.hasAmbiguousLayout && isPortraitLayout) {
            collectionView.collectionViewLayout = NothingCollectionViewLayout.landscapeCollectionLayout()
            isPortraitLayout = false
        } else if (!collectionView.hasAmbiguousLayout && !isPortraitLayout) {
            collectionView.collectionViewLayout = NothingCollectionViewLayout.portraitCollectionLayout()
            isPortraitLayout = true
        }
        cell.setNeedsDisplay() // Called to redraw the shadow layer
    }
}
