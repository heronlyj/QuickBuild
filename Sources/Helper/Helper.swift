//
//  Helper.swift
//  QuickBuild
//
//  Created by lyj on 21/09/2016.
//  Copyright © 2016 heronlyj. All rights reserved.
//

import Foundation

/**
 延时提交block 进入主队列执行
 
 - parameter seconds:    延时时间
 - parameter completion: 执行的程序
 */
extension DispatchQueue {
    
    // MARK: - 安全的主线程
    public static func safeMain(_ block: @escaping ()->()) {
        if Thread.isMainThread { block() }
        else { DispatchQueue.main.async(execute: block) }
    }
    
    public static func delay(seconds: TimeInterval, completion: @escaping ()->()) {
        let after = DispatchTime.now() + seconds
        DispatchQueue.main.asyncAfter(deadline: after, execute: completion)
        
        
    }
}

/**
 全局控制台方法
 - parameter message: "输入想要打印的信息"
 - parameter file:    文件
 - parameter method:  方法
 - parameter line:    行数
 */
public func printLogDebug<T>(_ message: T, file: String = #file, method: String = #function, line: Int = #line) {
    #if DEBUG
        print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
    #endif
}
