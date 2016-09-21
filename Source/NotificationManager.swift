//
//  NotificationManager.swift
//  QuickBuild
//
//  Created by lyj on 21/09/2016.
//  Copyright © 2016 heronlyj. All rights reserved.
//

import Foundation

public class NotificationManager {
    
    private var observerTokens = [Any]()
    
    deinit {
        deregisterAll()
    }
    
    public init() {}
    
    public func addObserver(forName name: Notification.Name, forObject object: Any? = nil, block: @escaping ((Notification!) -> Void)) {
        let token = NotificationCenter.default.addObserver(forName: name, object: object, queue: nil, using: block)
        observerTokens.append(token)
    }
    
    public func deregisterAll() {
        for token in observerTokens {
            NotificationCenter.default.removeObserver(token)
        }
        observerTokens = []
    }
    
    public static func post(name: Notification.Name, userInfo: [AnyHashable: Any]? ) {
        NotificationCenter.default.post(name: name, object: nil, userInfo: userInfo)
    }
    public static func post(name: Notification.Name) {
        NotificationCenter.default.post(name: name, object: nil)
    }
    
}
