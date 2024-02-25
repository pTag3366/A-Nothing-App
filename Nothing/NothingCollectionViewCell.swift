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
        contentMode = .redraw
    }
    
    override func draw(_ layer: CALayer, in ctx: CGContext) {
//        let layer = CALayer()
        layer.frame = frame
        layer.backgroundColor = UIColor.darkGray.cgColor
             
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 5
        layer.shadowOpacity = 1
             
        let shadowHeight: CGFloat = 10
        let shadowPath = CGMutablePath()
        shadowPath.move(to: CGPoint(x: layer.shadowRadius,
                                    y: -shadowHeight))
        shadowPath.addLine(to: CGPoint(x: layer.shadowRadius,
                                       y: shadowHeight))
        shadowPath.addLine(to: CGPoint(x: layer.bounds.width - layer.shadowRadius,
                                       y: shadowHeight))
        shadowPath.addLine(to: CGPoint(x: layer.bounds.width - layer.shadowRadius,
                                       y: -shadowHeight))
             
        shadowPath.addQuadCurve(to: CGPoint(x: layer.shadowRadius,
                                            y: -shadowHeight),
                                control: CGPoint(x: layer.bounds.width / 2,
                                                 y: shadowHeight))
             
        layer.shadowPath = shadowPath
//        self.layer.shadowPath = shadowPath
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
                     
        let shadowHeight: CGFloat = 10
        let shadowPath = CGMutablePath()
        shadowPath.move(to: CGPoint(x: layer.shadowRadius,
                                    y: -shadowHeight))
        shadowPath.addLine(to: CGPoint(x: layer.shadowRadius,
                                       y: shadowHeight))
        shadowPath.addLine(to: CGPoint(x: layer.bounds.width - layer.shadowRadius,
                                       y: shadowHeight))
        shadowPath.addLine(to: CGPoint(x: layer.bounds.width - layer.shadowRadius,
                                       y: -shadowHeight))
        
        shadowPath.addQuadCurve(to: CGPoint(x: layer.shadowRadius,
                                            y: -shadowHeight),
                                control: CGPoint(x: layer.bounds.width / 2,
                                                 y: shadowHeight))
        
        textField.layer.shadowPath = shadowPath
        //        self.layer.shadowPath = shadowPath
    }
}
