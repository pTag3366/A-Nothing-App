//
//  NothingCollectionViewCell.swift
//  Nothing
//
//  Created by Jose Benitez on 2/20/24.
//

import UIKit

class NothingCollectionViewCell: UICollectionViewCell {
    
    static let nothingCollectionViewCellId = "NothingCollectionViewCellReuseId"
    var textView: NothingTextView!
    var stackView: NothingStackView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textView = NothingTextView(frame: frame)
        stackView = NothingStackView(frame: frame)
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
//        translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
//            trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
//            bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
//            topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor)
//        ])
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        let inset = CGFloat(0)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: inset),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: inset)
        ])
        stackView.addArrangedSubview(textView)
        stackView.alignment = .top
//        stackView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
//        stackView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        let textViewInsets = CGFloat(0)
        textView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -textViewInsets),
            textView.topAnchor.constraint(equalTo: stackView.topAnchor, constant: textViewInsets),
            textView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 0)
        ])
        
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = CGColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
    }
}
