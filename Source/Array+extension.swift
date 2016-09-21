//
//  Array+extension.swift
//  QuickBuild
//
//  Created by lyj on 21/09/2016.
//  Copyright © 2016 heronlyj. All rights reserved.
//

import Foundation

public extension Array {
    
    /// 安全的下标引用
    public subscript (safe index: Int) -> Element? {
        return index >= 0 && index < count ? self[index] : nil
    }
    
}
