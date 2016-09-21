//
//  Int+extension.swift
//  QuickBuild
//
//  Created by lyj on 21/09/2016.
//  Copyright © 2016 heronlyj. All rights reserved.
//

import Foundation

public extension Int {
    
    //
    // let a: CGFloat = 2
    // let b = 3
    //
    // let c = a/b          error
    // let c = a.cgFloat/b  success
    
    public var cgFloat: CGFloat {
        return CGFloat(self)
    }
}
