//
//  NothingStackView.swift
//  Nothing
//
//  Created by Jose Benitez on 2/28/24.
//

import UIKit

class NothingStackView: UIStackView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        drawShadowLayer(rect)
    }
    
    func drawShadowLayer(_ rect: CGRect) {
        let shadowPath = CGMutablePath()
        let shadowHeight: CGFloat = 20
        let shadowRadius: CGFloat = 1
        let yOffset: CGFloat = -shadowHeight - shadowRadius
        let newRect = CGRectMake(rect.origin.x, rect.origin.y, rect.width, rect.height + yOffset)
        
        layer.borderWidth = 1.0
        layer.borderColor = CGColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        
        layer.frame = newRect
        layer.backgroundColor = UIColor.clear.cgColor
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = 1
        
        shadowPath.move(to: CGPoint(x: newRect.minX, y: newRect.maxY))
        shadowPath.addLine(to: CGPoint(x: newRect.maxX, y: newRect.maxY))
        shadowPath.addLine(to: CGPoint(x: newRect.maxX, y: newRect.maxY + shadowHeight))
        shadowPath.addQuadCurve(to: CGPoint(x: newRect.minX, y: newRect.maxY + shadowHeight), control: CGPoint(x: newRect.midX, y: newRect.maxY))
        
        layer.shadowPath = shadowPath
    }
}
