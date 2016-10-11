//
//  UIImage+extension.swift
//  QuickBuild
//
//  Created by lyj on 11/10/2016.
//  Copyright © 2016 heronlyj. All rights reserved.
//

import UIKit

public extension UIImage {
    
    public static func drawImage(size: CGSize, color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        color.set()
        UIRectFill(CGRect(origin: CGPoint.zero, size: size))
        guard let colorImage = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()
        return colorImage
    }
    
}
