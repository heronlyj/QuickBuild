//
//  GradientView.swift
//  QuickBuild
//
//  Created by lyj on 10/10/2016.
//  Copyright © 2016 heronlyj. All rights reserved.
//

import UIKit

@IBDesignable
public class GradientView: UIView {
    
    @IBInspectable public var startColor: UIColor = UIColor.clear {
        didSet { setNeedsDisplay() }
    }
    @IBInspectable public var endColor: UIColor = UIColor.black {
        didSet { setNeedsDisplay() }
    }

    override public func draw(_ rect: CGRect) {
        
        guard let currentContext = UIGraphicsGetCurrentContext() else { return }
        
        currentContext.saveGState();
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        guard let startColorComponents = startColor.cgColor.components,
            let endColorComponents = endColor.cgColor.components else { return }
        
        var colorComponents = [
            startColorComponents[0],
            startColorComponents[1],
            startColorComponents[2],
            startColorComponents[3],
            endColorComponents[0],
            endColorComponents[1],
            endColorComponents[2],
            endColorComponents[3]
        ]
        
        var locations:[CGFloat] = [0.0, 1.0]
        
        guard let gradient = CGGradient(colorSpace: colorSpace,colorComponents: &colorComponents,locations: &locations,count: 2) else { return }
        
        let startPoint = CGPoint(x: 0, y: 0)
        let endPoint = CGPoint(x: 0, y: bounds.height)
        
        currentContext.drawLinearGradient(gradient,start: startPoint,end: endPoint, options: [])
        currentContext.restoreGState()
    }

}
