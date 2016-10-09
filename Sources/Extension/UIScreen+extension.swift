//
//  UIScreen+extension.swift
//  QuickBuild
//
//  Created by lyj on 21/09/2016.
//  Copyright © 2016 heronlyj. All rights reserved.
//

import UIKit

public typealias Screen = UIScreen

extension Screen {
    
    public static var size: CGSize { return UIScreen.main.bounds.size }
    public static var width: CGFloat { return size.width }
    public static var height: CGFloat { return size.height }
    
}
