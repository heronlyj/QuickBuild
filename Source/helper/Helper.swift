//
//  Helper.swift
//  QuickBuild
//
//  Created by lyj on 21/09/2016.
//  Copyright © 2016 heronlyj. All rights reserved.
//

import Foundation

//let OnePixelLineColor = UIColor(hexString: "#BFC0C0")


/**
 延时提交block 进入主队列执行
 
 - parameter seconds:    延时时间
 - parameter completion: 执行的程序
 */
public func delay(seconds: Double, completion:@escaping ()->()) {
    
    let popTime = DispatchTime.now() + Double(Int64( Double(NSEC_PER_SEC) * seconds )) / Double(NSEC_PER_SEC)
    
    DispatchQueue.main.asyncAfter(deadline: popTime) {
        completion()
    }
}

/**
 主线程
 
 - parameter block: <#block description#>
 */
public func dispatch_async_safely_main_queue(_ block: @escaping ()->()) {
    if Thread.isMainThread {
        block()
    } else {
        DispatchQueue.main.async {
            block()
        }
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
