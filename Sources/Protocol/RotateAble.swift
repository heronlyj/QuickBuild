//
//  RotateAble.swift
//  QuickBuild
//
//  Created by lyj on 22/09/2016.
//  Copyright © 2016 heronlyj. All rights reserved.
//

import UIKit

/**
 *  单个页面是否支持旋转
 */
public protocol RotateAble {
    var autoRotateAble: Bool { get }
    var supportedOrientations: UIInterfaceOrientationMask { get }
    var preferredOrientationForPresentation: UIInterfaceOrientation { get }
}

public extension RotateAble {
    public var autoRotateAble: Bool { return false }
    public var supportedOrientations: UIInterfaceOrientationMask { return .portrait }
    public var preferredOrientationForPresentation: UIInterfaceOrientation { return .portrait }
}

/*
 
// 举例 作为项目的根视图
extension DrawerController {
    
    public override func shouldAutorotate() -> Bool {
        return centerViewController?.shouldAutorotate() ?? false
    }
    
    public override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return centerViewController?.supportedInterfaceOrientations() ?? .portrait
    }
    
}

// DrawerController 的 centerViewController
extension BagRootTabBarViewController {
    
    override func shouldAutorotate() -> Bool {
        return selectedViewController?.shouldAutorotate() ?? false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return selectedViewController?.supportedInterfaceOrientations() ?? .portrait
    }
    
}

extension BagNavigationController {
    
    override func shouldAutorotate() -> Bool {
        if let vc = visibleViewController as? RotateAble {
            return vc.autoRotateAble
        } else {
            return false
        }
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if let vc = visibleViewController as? RotateAble {
            return vc.supportedOrientations
        } else {
            return .portrait
        }
    }
    
}
 
 */
