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
        backgroundColor = .blue
        accessibilityLabel = "NothingCollectionViewReusableView"
        configure()
    }
    
    private func configure() {
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        let inset = CGFloat(0)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
            label.topAnchor.constraint(equalTo: topAnchor, constant: inset),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset)
        ])
        label.font = UIFont.preferredFont(forTextStyle: .title3)
    }
}

