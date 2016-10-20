//
//  Listener.swift
//  QuickBuild
//
//  Created by lyj on 21/09/2016.
//  Copyright © 2016 heronlyj. All rights reserved.
//

import Foundation

public struct Listener<T>: Hashable {
    
    public typealias Action = (T) -> Void
    
    public let name: String
    public let action: Action
    
    public var hashValue: Int {
        return name.hashValue
    }
    
}

public func ==<T>(lhs: Listener<T>, rhs: Listener<T>) -> Bool {
    return lhs.name == rhs.name
}

public class ListenAble<T> {
    
    public typealias SetterAction = (T) -> Void
    
    public var value: T {
        didSet {
            listenerSet.forEach {
                $0.action(value)
            }
        }
    }
    
    var setterAction: SetterAction
    var listenerSet = Set<Listener<T>>()
    
    public init(v: T, action: @escaping SetterAction) {
        value = v
        setterAction = action
    }
    
    public func bindListener(with name: String, action: @escaping Listener<T>.Action) {
        let listner = Listener(name: name, action: action)
        listenerSet.insert(listner)
    }
    
    public func bindAndFireListener(name: String, action: @escaping Listener<T>.Action) {
        bindListener(with: name, action: action)
        action(value)
    }
    
    public func removeListener(with name: String) {
        if let index = listenerSet.index(where: { $0.name == name }) {
            listenerSet.remove(at: index)
        }
    }
    
    public func removeAll() {
        listenerSet.removeAll(keepingCapacity: false)
    }
    
}


public struct ListenerName {
    public let name: String
}

public extension NSObject {
    public var listenerName: ListenerName {
        return ListenerName(name: String(describing: self))
    }
}





