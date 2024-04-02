//
//  NothingCollectionViewReusableView.swift
//  Nothing
//
//  Created by Jose Benitez on 2/21/24.
//

import UIKit

class NothingCollectionViewReusableView: UICollectionReusableView {
    
    private let label = UILabel()
    
    static let sectionHeader = "SectionHeaderReuseId"
    private var headerColor: UIColor = UIColor.white
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        accessibilityLabel = "NothingCollectionViewReusableView"
        registerForTraitChanges([UITraitUserInterfaceStyle.self], action: #selector(toggleHeaderColor))
        toggleHeaderColor()
        configure()
    }
    
    @objc func toggleHeaderColor() {
        headerColor = traitCollection.userInterfaceStyle == .light ? UIColor.white : UIColor.black
        backgroundColor = headerColor
    }
    
    func setSectionTitle(_ text: String) {
        label.text = text
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
        label.font = UIFont.preferredFont(forTextStyle: .extraLargeTitle2)
    }
}

