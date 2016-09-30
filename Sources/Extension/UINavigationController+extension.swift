//
//  UINavigationController+extension.swift
//  QuickBuild
//
//  Created by lyj on 22/09/2016.
//  Copyright © 2016 heronlyj. All rights reserved.
//

import UIKit

protocol PopControlAble {
    func shouldPop(controller: UINavigationController) -> Bool
}

// 使用了全局变量来替代单例效果
fileprivate var pop_swizzleInited: Bool = false

extension UINavigationController: UIGestureRecognizerDelegate {
    
    private var originDelegate: String {
        return "originDelegate"
    }
    
    // 初始化的时候 交换方法
    override open class func initialize() {
        
        if self != UINavigationController.self {
            return
        }
        
        guard !pop_swizzleInited else { return }
        
        let cls: AnyClass! = UINavigationController.self
        
        // 虽然 UINavigationController 已经实现了 UINavigationBarDelegate 但是这里不能省略前的，会报错
        let originalSelector = #selector(UINavigationBarDelegate.navigationBar(_:shouldPop:))
        let swizzledSelector = #selector(pop_navigationBar(navigationBar:shouldPop:))
        
        let originalMethod = class_getInstanceMethod(cls, originalSelector)
        let swizzledMethod = class_getInstanceMethod(cls, swizzledSelector)
        
        let didAddMethod = class_addMethod(
            cls,
            originalSelector,
            method_getImplementation(swizzledMethod),
            method_getTypeEncoding(swizzledMethod)
        )
        
        if didAddMethod {
            class_replaceMethod(
                cls,
                swizzledSelector,
                method_getImplementation(originalMethod),
                method_getTypeEncoding(originalMethod)
            )
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
        
        
        let originalGestureSelector = #selector(viewWillAppear(_:))
        let swizzledGestureSelector = #selector(pop_viewWillAppear(animated:))
        
        let originalGestureMethod = class_getInstanceMethod(cls, originalGestureSelector)
        let swizzledGestureMethod = class_getInstanceMethod(cls, swizzledGestureSelector)
        
        let didAddGestureMethod = class_addMethod(
            cls,
            originalGestureSelector,
            method_getImplementation(swizzledGestureMethod),
            method_getTypeEncoding(swizzledGestureMethod)
        )
        
        if didAddGestureMethod {
            class_replaceMethod(
                cls,
                swizzledGestureSelector,
                method_getImplementation(originalGestureMethod),
                method_getTypeEncoding(originalGestureMethod)
            )
        } else {
            method_exchangeImplementations(originalGestureMethod, swizzledGestureMethod)
        }
        
        pop_swizzleInited = true
    }
    
    func pop_viewWillAppear(animated: Bool) {
        self.pop_viewWillAppear(animated: animated)
        
        objc_setAssociatedObject(self, originDelegate, self.interactivePopGestureRecognizer, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN);
        
        self.interactivePopGestureRecognizer?.delegate = self
    }
    
    // backButton pop
    func pop_navigationBar(navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        
        guard let vc = self.topViewController, item == vc.navigationItem else { return true }
        
        if let popController = vc as? PopControlAble {
            if popController.shouldPop(controller: self) {
                return pop_navigationBar(navigationBar: navigationBar, shouldPop: item)
            } else {
                return false
            }
        } else {
            return pop_navigationBar(navigationBar: navigationBar, shouldPop: item)
        }
        
    }
    
    // 左划手势
    public func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let popController = self.topViewController as? PopControlAble,
            gestureRecognizer == self.interactivePopGestureRecognizer {
            return popController.shouldPop(controller: self)
        }
        return true
    }
    
}
