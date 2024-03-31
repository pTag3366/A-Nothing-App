//
//  NothingStackView.swift
//  Nothing
//
//  Created by Jose Benitez on 2/28/24.
//

import UIKit

class NothingStackView: UIStackView {
    
    var dy: CGFloat {
        return frame.height
    }
    private var shadowColor: CGColor = UIColor.black.cgColor
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        drawShadowLayer(rect)
    }
    
    private func configure() {
        backgroundColor = .clear
        contentMode = .redraw
        registerForTraitChanges([UITraitUserInterfaceStyle.self], action: #selector(toggleShadowColor))
    }
    
    @objc func toggleShadowColor() {
        shadowColor = shadowColor == UIColor.black.cgColor ? UIColor.white.cgColor : UIColor.black.cgColor
    }
    
    func drawShadowLayer(_ rect: CGRect) {
        let offset: CGRect = rect.offsetBy(dx: 0, dy: dy - 10)

        let shadowPath = CGMutablePath()
        let shadowHeight: CGFloat = 20
        let shadowRadius: CGFloat = 2
        let yOffset: CGFloat = -shadowHeight - shadowRadius
        let xOffset: CGFloat = -shadowHeight - shadowRadius

        assert(layer.frame.equalTo(frame))
        let newRect = offset
        
        layer.backgroundColor = UIColor.clear.cgColor
        layer.shadowColor = shadowColor
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = 1
        
        shadowPath.move(to: CGPoint(x: newRect.minX + abs(xOffset), y: newRect.minY + abs(yOffset)))
        shadowPath.addLine(to: CGPoint(x: newRect.maxX - abs(xOffset), y: newRect.minY + abs(yOffset)))
        shadowPath.addLine(to: CGPoint(x: newRect.maxX - abs(xOffset), y: newRect.minY + abs(yOffset) + shadowHeight))
        shadowPath.addQuadCurve(to: CGPoint(x: newRect.minX + abs(xOffset), y: newRect.minY + abs(yOffset) + shadowHeight), control: CGPoint(x: newRect.midX, y: newRect.minY + abs(yOffset)))
        
        layer.shadowPath = shadowPath
    }
}
