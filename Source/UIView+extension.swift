//
//  UIView+extension.swift
//  QuickBuild
//
//  Created by lyj on 21/09/2016.
//  Copyright © 2016 heronlyj. All rights reserved.
//

import Foundation


extension UIView {
    // 截取视图的内容为 一张图片
    public func screenShot() -> UIImage? {
        guard let currentContext = UIGraphicsGetCurrentContext() else { return nil }
        let size = CGSize(width: bounds.width, height: bounds.height)
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        self.layer.render(in: currentContext)
        let viewImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return viewImage
    }
    
}



public protocol LoadNibable {}

public extension LoadNibable where Self: UIView {
    
    static func loadFromNib() -> Self? {
        return Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)?.first as? Self
    }
    
}

extension UIView: LoadNibable {}
