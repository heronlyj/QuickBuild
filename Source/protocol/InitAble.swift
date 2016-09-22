//
//  InitAble.swift
//  QuickBuild
//
//  Created by lyj on 22/09/2016.
//  Copyright © 2016 heronlyj. All rights reserved.
//

import Foundation

/**
 *  给所有 实现 此协议的对象 扩展一个 一次初始化一个数组的 静态方法
 */
public protocol InitAble {
    init(data: Any)
}

public extension InitAble {
    
    public static func initWithArr(data: Any) -> [Self] {
        guard let list = data as? [Any] else { return [] }
        return list.map { Self(data: $0) }
    }
    
}
