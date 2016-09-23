//
//  AlertHelper.swift
//  QuickBuild
//
//  Created by lyj on 21/09/2016.
//  Copyright © 2016 heronlyj. All rights reserved.
//

import UIKit

public typealias AlertAction = () -> Void
public typealias TextFieldAlertActionItem = ([(inputText: String, placeholder: String)]) -> Void

public struct AlertActionItem {
    
    let name    : String
    let action  : () -> Void
    
    public init(name: String, action: @escaping () -> Void) {
        self.name = name
        self.action = action
    }
}

public struct AlertHelper {
    
    public static func showAlert(
        title       : String? = nil,
        message     : String,
        style       : UIAlertControllerStyle,
        actionName  : String = "确定",
        action      : AlertAction? = nil,
        cancelAction: AlertAction? = { () -> Void in },
        complaction : AlertAction? = nil)
    {
        
        guard let window = UIApplication.shared.keyWindow, let vc = window.rootViewController else { return }
        
        showAlert(in: vc, title: title, message: message, style: style, actionName: actionName, action: action, cancelAction: cancelAction, complaction: complaction)
        
    }
    
    
    public static func showAlert(in
        viewController   : UIViewController,
        title            : String? = nil,
        message          : String? = nil,
        style            : UIAlertControllerStyle,
        actionName       : String = "确定",
        action           : AlertAction? = nil,
        cancelAction     : AlertAction? = { () -> Void in },
        complaction      : AlertAction? = nil)
    {
        
        DispatchQueue.safeMain {
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
            
            let alertAction = UIAlertAction(title: actionName, style: UIAlertActionStyle.default) { _ in
                DispatchQueue.safeMain { _ in
                    if let action = action {
                        action()
                    }
                }
            }
            
            if let cancelAction = cancelAction {
                let cancel = UIAlertAction(title: "取消", style: .cancel) { _ in
                    cancelAction()
                }
                alertController.addAction(cancel)
            }
            
            alertController.addAction(alertAction)
            
            viewController.present(alertController, animated: true, completion: complaction)
        }
        
    }
    
    
    public static func showActionSheet(
        title   : String? = nil,
        message : String? = nil,
        actions : [AlertActionItem])
    {
        
        guard let window = UIApplication.shared.keyWindow, let viewController = window.rootViewController else { return }
        
        showActionSheet(in: viewController, actions: actions)
    }
    
    public static func showActionSheet(in
        viewController : UIViewController,
        title          : String? = nil,
        message        : String? = nil,
        actionName     : String = "确定",
        action         : @escaping AlertAction)
    {
        showActionSheet(
            in      : viewController,
            title   : title,
            message : message,
            actions : [AlertActionItem(name: actionName, action: action)]
        )
    }
    
    public static func showActionSheet(in
        viewController : UIViewController,
        title          : String? = nil,
        message        : String? = nil,
        actions        : [AlertActionItem])
    {
        
        DispatchQueue.safeMain {
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            
            for actionItem in actions {
                
                let alertAction = UIAlertAction(title: actionItem.name, style: UIAlertActionStyle.default) { _ in
                    actionItem.action()
                }
                
                alertController.addAction(alertAction)
            }
            let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            alertController.addAction(cancel)
            
            viewController.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    public static func showTextField(in
        viewController : UIViewController,
        title          : String?,
        message        : String?,
        placeHolder    : String = "",
        action         : @escaping (String) -> Void)
    {
        
        DispatchQueue.safeMain { _ in
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let cancel = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
            
            let alertAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.default) { _ in
                
                guard
                    let firstTextField = alertController.textFields?.first,
                    let text = firstTextField.text
                    else { return }
                
                DispatchQueue.safeMain { _ in
                    action(text)
                }
                
            }
            alertController.addAction(cancel)
            alertController.addAction(alertAction)
            
            alertController.addTextField { (textField: UITextField) -> Void in
                // 这里可以对这个TextField 做一些配置
                textField.placeholder = placeHolder
            }
            
            viewController.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    
    public static func showTextFields(in
        viewController : UIViewController,
        title          : String? = nil,
        message        : String? = nil,
        placeholders   : [String] = [],
        completeAction : @escaping TextFieldAlertActionItem)
    {
        
        DispatchQueue.safeMain { _ in
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            
            let alertAction = UIAlertAction(title: "确定", style: .default) { _ in
                
                guard let textFields = alertController.textFields else {
                    DispatchQueue.safeMain { _ in
                        completeAction([])
                    }
                    return
                }
                
                let textResult = textFields
                    .enumerated()
                    .map{(inputText: $1.text ?? "", placeholder: $0 < placeholders.count ? placeholders[$0] : "")}
                
                DispatchQueue.safeMain { _ in
                    completeAction(textResult)
                }
                
            }
            
            alertController.addAction(cancel)
            alertController.addAction(alertAction)
            
            if placeholders.isEmpty {
                alertController.addTextField { $0.placeholder = "请输入内容" }
            } else {
                for placeholder in placeholders {
                    alertController.addTextField { $0.placeholder = placeholder }
                }
            }
            
            viewController.present(alertController, animated: true, completion: nil)
            
        }
        
    }
    
    
    public static func warning(message: String, action: (() -> Void)? = nil) {
        showAlert(message: message, style: .alert, action: action, complaction: nil)
    }
}
