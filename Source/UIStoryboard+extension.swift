//
//  UIStoryboard+extension.swift
//  QuickBuild
//
//  Created by lyj on 21/09/2016.
//  Copyright © 2016 heronlyj. All rights reserved.
//

import Foundation


extension UIStoryboard {
    
    public convenience init(name: String) {
        self.init(name: name, bundle: Bundle.main)
    }
    
    public func instantiate(id identifier: String) -> UIViewController {
        return instantiateViewController(withIdentifier: identifier)
    }
    
    public var initialer: UIViewController? {
        return instantiateInitialViewController()
    }
    
}
