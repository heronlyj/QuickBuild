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
    
    public func registerObserver(name: String, forObject object: Any? = nil, block: @escaping ((Notification!) -> Void)) {
        let token = NotificationCenter.default.addObserver(forName: Notification.Name(name), object: object, queue: nil, using: block)
        observerTokens.append(token)
    }
    
    public func deregisterAll() {
        for token in observerTokens {
            NotificationCenter.default.removeObserver(token)
        }
        observerTokens = []
    }
    
    static func postNotification(name: String, userInfo: [AnyHashable: Any]? ) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: name), object: nil, userInfo: userInfo)
    }
    static func postNotification(name: String) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: name), object: nil)
    }
    
}
