//
//  NothingCollectionViewCell.swift
//  Nothing
//
//  Created by Jose Benitez on 2/20/24.
//

import UIKit

class NothingCollectionViewCell: UICollectionViewCell {
    
    static let nothingCollectionViewCellId = "CollectionViewCell"
    let textView = NothingTextView()
    let stackView = NothingStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        accessibilityLabel = "NothingCollectionViewCell"
        contentMode = .redraw // sets the view to be redrawn when invoking setNeedsDisplay()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    func configure() {
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        let inset = CGFloat(10)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: inset),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: inset)
        ])
        stackView.addArrangedSubview(textView)
        stackView.alignment = .top
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 0),
            textView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -inset),
            textView.topAnchor.constraint(equalTo: stackView.topAnchor, constant: inset),
            textView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: -100)
        ])
        
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = CGColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
    }
}
