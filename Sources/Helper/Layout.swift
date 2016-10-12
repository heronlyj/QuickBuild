//
//  Layout.swift
//  QuickBuild
//
//  Created by lyj on 12/10/2016.
//  Copyright © 2016 heronlyj. All rights reserved.
//

import UIKit


typealias LayoutConstraint = NSLayoutConstraint

extension LayoutConstraint {
    
    public convenience init(item: UIView, attribute: NSLayoutAttribute, relatedBy: NSLayoutRelation = .equal, to: UIView?, multiplier: CGFloat = 1, constant: CGFloat = 0) {
        self.init(item: item, attribute: attribute, relatedBy: NSLayoutRelation.equal, toItem: to, attribute: attribute, multiplier: 1, constant: constant)
    }
    
}

extension UIView {
    
    public func layout(item: UIView, attribute: NSLayoutAttribute, relatedBy: NSLayoutRelation = .equal, to: UIView?, multiplier: CGFloat = 1, constant: CGFloat = 0) {
        
        if item.translatesAutoresizingMaskIntoConstraints {
            item.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraint(LayoutConstraint(item: item, attribute: attribute, relatedBy: relatedBy, to: to, multiplier: multiplier, constant: constant))
    }
    
}
