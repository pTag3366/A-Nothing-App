//
//  NothingCollectionViewReusableView.swift
//  Nothing
//
//  Created by Jose Benitez on 2/21/24.
//

import UIKit

class NothingCollectionViewReusableView: UICollectionReusableView {
    
    let label = UILabel()
    
    static let sectionHeader = "SectionHeaderReuseId"
    static let sectionFooter = "SectionFooterReuseId"
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        accessibilityLabel = "NothingCollectionViewReusableView"
        configure()
    }
    
    private func configure() {
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        label.font = UIFont.preferredFont(forTextStyle: .title3)
    }
}

