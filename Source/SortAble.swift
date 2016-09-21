//
//  SortAble.swift
//  QuickBuild
//
//  Created by lyj on 21/09/2016.
//  Copyright © 2016 heronlyj. All rights reserved.
//

import Foundation

public protocol SortAble: Hashable, Comparable, Equatable {
    var sortId: Int { get }
}

public func ==<T: SortAble>(lhs: T, rhs: T) -> Bool {
    return lhs.sortId == rhs.sortId
}

public func <<T: SortAble>(lhs: T, rhs: T) -> Bool {
    return lhs.sortId < rhs.sortId
}

public func <=<T: SortAble>(lhs: T, rhs: T) -> Bool {
    return lhs.sortId <= rhs.sortId
}

public func ><T: SortAble>(lhs: T, rhs: T) -> Bool {
    return lhs.sortId > rhs.sortId
}

public func >=<T: SortAble>(lhs: T, rhs: T) -> Bool {
    return lhs.sortId >= rhs.sortId
}

public extension SortAble {
    public var hashValue: Int {
        return sortId
    }
}
