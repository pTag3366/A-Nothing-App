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
    
    override func draw(_ rect: CGRect) {
        print("draw rect: ", rect.size)
        drawShadowLayer()
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
        textField.layer.cornerRadius = 5
        
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = CGColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        
        textField.layer.frame = frame
        textField.layer.backgroundColor = UIColor.gray.cgColor
                     
        textField.layer.shadowColor = UIColor.black.cgColor
        textField.layer.shadowRadius = 8
        textField.layer.shadowOpacity = 1
                     
//        let shadowHeight: CGFloat = 20      //Height of the shadow's path to be drawn
//        let shadowPath = CGMutablePath()
//        
//        let leadingXCoordinate = inset
//        let leadingYCoordinate = frame.height - textField.layer.shadowRadius - inset - inset //Substract top and bottom insets and shadowRadius
//        let trailingXCoordinate = frame.width - textField.layer.shadowRadius - inset - inset //Substract leading and trailing insets and shadowRadius
//        let trailingYCoordinate = frame.height - textField.layer.shadowRadius + shadowHeight
//        let midPathXCoordinate = (trailingXCoordinate - leadingXCoordinate) / 2
//        
//        let p0 = CGPoint(x: leadingXCoordinate, y: leadingYCoordinate)
//        let p1 = CGPoint(x: trailingXCoordinate, y: leadingYCoordinate)
//        let p2 = CGPoint(x: trailingXCoordinate, y: trailingYCoordinate)
//        let p3 = CGPoint(x: leadingXCoordinate, y: trailingYCoordinate)
//        let q1 = CGPoint(x: midPathXCoordinate, y: leadingYCoordinate)
//        
//        shadowPath.move(to: p0)
//        shadowPath.addLine(to: p1)
//        shadowPath.addLine(to: p2)
//        shadowPath.addQuadCurve(to: p3, control: q1)
//        
//        textField.layer.shadowPath = shadowPath
        drawShadowLayer()
    }
    
    func drawShadowLayer() {
        let inset: CGFloat = 10
        let shadowHeight: CGFloat = 20      //Height of the shadow's path to be drawn
        let shadowPath = CGMutablePath()
        
        let leadingXCoordinate = inset
        let leadingYCoordinate = frame.height - textField.layer.shadowRadius - inset - inset //Substract top and bottom insets and shadowRadius
        let trailingXCoordinate = frame.width - textField.layer.shadowRadius - inset - inset //Substract leading and trailing insets and shadowRadius
        let trailingYCoordinate = frame.height - textField.layer.shadowRadius + shadowHeight
        let midPathXCoordinate = (trailingXCoordinate - leadingXCoordinate) / 2
        
        let p0 = CGPoint(x: leadingXCoordinate, y: leadingYCoordinate)
        let p1 = CGPoint(x: trailingXCoordinate, y: leadingYCoordinate)
        let p2 = CGPoint(x: trailingXCoordinate, y: trailingYCoordinate)
        let p3 = CGPoint(x: leadingXCoordinate, y: trailingYCoordinate)
        let q1 = CGPoint(x: midPathXCoordinate, y: leadingYCoordinate)
        
        shadowPath.move(to: p0)
        shadowPath.addLine(to: p1)
        shadowPath.addLine(to: p2)
        shadowPath.addQuadCurve(to: p3, control: q1)
        
        textField.layer.shadowPath = shadowPath
    }
}
