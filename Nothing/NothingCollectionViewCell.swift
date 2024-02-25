//
//  NothingCollectionViewCell.swift
//  Nothing
//
//  Created by Jose Benitez on 2/20/24.
//

import UIKit

class NothingCollectionViewCell: UICollectionViewCell {
    
    static let collectionViewCellId = "CollectionViewCell"
    let textField = NothingTextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
//        backgroundColor = .gray
//        layer.borderWidth = 1.0
//        layer.borderColor = CGColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
//        contentView.layer.cornerRadius = 8
//        layer.shadowOpacity = 0.2
//        layer.shadowRadius = 6.0
        contentMode = .redraw //??
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    func configure() {
        addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.adjustsFontForContentSizeCategory = true
        let inset = CGFloat(10)
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
            textField.topAnchor.constraint(equalTo: topAnchor, constant: inset),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset)
        ])
        
        textField.font = UIFont.preferredFont(forTextStyle: .title3)
        textField.backgroundColor = .cyan
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = CGColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        textField.layer.cornerRadius = 8
        
        textField.layer.frame = frame
        textField.layer.backgroundColor = UIColor.darkGray.cgColor
                     
        textField.layer.shadowColor = UIColor.black.cgColor
        textField.layer.shadowRadius = 5
        textField.layer.shadowOpacity = 1
                     
        let shadowHeight: CGFloat = 20
        let shadowPath = CGMutablePath()
        
        let viewHeight = frame.size.height
        let p0 = CGPoint(x: layer.shadowRadius, y: -shadowHeight + viewHeight)
        let p1 = CGPoint(x: layer.bounds.width, y: -shadowHeight + viewHeight)
        let p2 = CGPoint(x: layer.bounds.width - layer.shadowRadius, y: shadowHeight + viewHeight)
        let p3 = CGPoint(x: layer.shadowRadius, y: shadowHeight + viewHeight)
        let q0 = CGPoint(x: layer.bounds.width, y: -shadowHeight + viewHeight)
        let q1 = CGPoint(x: layer.bounds.width / 2, y: -shadowHeight + viewHeight)
        
        shadowPath.move(to: p0)
        shadowPath.addLine(to: p1)
        shadowPath.addLine(to: p2)
             
        shadowPath.addQuadCurve(to: p3, control: q1)
        
        textField.layer.shadowPath = shadowPath
    }
}
