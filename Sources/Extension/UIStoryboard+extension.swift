//
//  UIStoryboard+extension.swift
//  QuickBuild
//
//  Created by lyj on 21/09/2016.
//  Copyright © 2016 heronlyj. All rights reserved.
//

import UIKit


extension UIStoryboard {
    public struct Name {
        public var rawValue: String
        public init(_ rawValue: String) {
            self.rawValue = rawValue
        }
    }
}

extension UIStoryboard {
    
    public convenience init(name: UIStoryboard.Name, bundle: Bundle = .main) {
        self.init(name: name.rawValue, bundle: bundle)
    }
    
    public func instantiate(id identifier: String) -> UIViewController {
        return instantiateViewController(withIdentifier: identifier)
    }
    
    public var initialer: UIViewController? {
        return instantiateInitialViewController()
    }
    
}
