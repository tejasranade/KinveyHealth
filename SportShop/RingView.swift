//
//  RingView.swift
//  KinveyHealth
//
//  Created by Victor Hugo on 2017-05-03.
//  Copyright © 2017 Kinvey. All rights reserved.
//

import UIKit

@IBDesignable
class RingView: UIView {

    @IBInspectable
    var ringColor = UIColor.green {
        didSet {
            shapeLayer.strokeColor = ringColor.cgColor
        }
    }
    
    @IBInspectable
    var lineWidth = CGFloat(1) {
        didSet {
            shapeLayer.lineWidth = lineWidth
        }
    }
    
    @IBInspectable
    var progress = CGFloat(0) {
        didSet {
            shapeLayer.strokeEnd = progress
        }
    }
    
    override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }
    
    var shapeLayer: CAShapeLayer {
        return layer as! CAShapeLayer
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let minSize = min(bounds.size.width, bounds.size.height) / 2
        let pi2 = Double.pi / 2
        shapeLayer.path = UIBezierPath(
            arcCenter: center,
            radius: minSize,
            startAngle: CGFloat(-pi2),
            endAngle: CGFloat(3 * pi2),
            clockwise: true
            ).cgPath
        shapeLayer.strokeStart = 0
        shapeLayer.fillColor = nil
    }

}
