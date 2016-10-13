//
//  Layout.swift
//  QuickBuild
//
//  Created by lyj on 12/10/2016.
//  Copyright © 2016 heronlyj. All rights reserved.
//

import UIKit


typealias LayoutConstraint = NSLayoutConstraint

public struct Layout {
    public let view: UIView
    public init(_ view: UIView) {
        self.view = view
    }
}

extension Layout {

    public func layout(item: UIView, attribute: NSLayoutAttribute, relatedBy: NSLayoutRelation = .equal, to: UIView?, attribute toAttribute: NSLayoutAttribute, multiplier: CGFloat = 1, constant: CGFloat) {
        
        if item.translatesAutoresizingMaskIntoConstraints {
            item.translatesAutoresizingMaskIntoConstraints = false
        }
        
        view.addConstraint(NSLayoutConstraint(item: item, attribute: attribute, relatedBy: relatedBy, toItem: to, attribute: toAttribute, multiplier: multiplier, constant: constant))
    }
    
}

extension LayoutConstraint {
    
    public convenience init(item: UIView, attribute: NSLayoutAttribute, relatedBy: NSLayoutRelation = .equal, to: UIView?, multiplier: CGFloat = 1, constant: CGFloat) {
        self.init(item: item, attribute: attribute, relatedBy: NSLayoutRelation.equal, toItem: to, attribute: attribute, multiplier: 1, constant: constant)
    }
    
}


extension UIView {
    
    /// Layout mean AutoLayout
    public var al: Layout {
        get { return Layout(self) }
        set { }
    }
}
