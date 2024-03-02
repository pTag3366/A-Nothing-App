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
        contentMode = .redraw
        configure()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        drawShadowLayer(rect)
    }
    
    func configure() {
        
    }
    
    func drawShadowLayer(_ rect: CGRect) {
        let shadowPath = CGMutablePath()
        let shadowHeight: CGFloat = 20
        let shadowRadius: CGFloat = 1
        let yOffset: CGFloat = -shadowHeight - shadowRadius
        let xOffset: CGFloat = -shadowHeight - shadowRadius

        assert(layer.frame.equalTo(frame))
        let newRect = CGRect(x: layer.frame.origin.x, y: layer.frame.origin.y, width: layer.frame.width, height: layer.frame.height)
        
        
        layer.backgroundColor = UIColor.clear.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = 1
        
        shadowPath.move(to: CGPoint(x: newRect.minX + abs(xOffset), y: newRect.maxY))
        shadowPath.addLine(to: CGPoint(x: newRect.maxX - abs(xOffset), y: newRect.maxY))
        shadowPath.addLine(to: CGPoint(x: newRect.maxX - abs(xOffset), y: newRect.maxY + shadowHeight))
        shadowPath.addQuadCurve(to: CGPoint(x: newRect.minX + abs(xOffset), y: newRect.maxY + shadowHeight), control: CGPoint(x: newRect.midX, y: newRect.maxY))
        
        layer.shadowPath = shadowPath
    }
}
