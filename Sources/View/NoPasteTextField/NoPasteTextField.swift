//
//  NoPasteTextField.swift
//  QuickBuild
//
//  Created by lyj on 20/10/2016.
//  Copyright © 2016 heronlyj. All rights reserved.
//

import UIKit

@IBDesignable
public class NoPasteTextField: UITextField {

    @IBInspectable public var isPasteEnable: Bool = false
    @IBInspectable public var isSelctedEnable: Bool = false
    @IBInspectable public var isSelectedAllEnable: Bool = false

    override public func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        
        switch action {
        case #selector(paste(_:)): return isPasteEnable
        case #selector(select(_:)): return isSelctedEnable
        case #selector(selectAll(_:)): return isSelectedAllEnable
        default: break
        }
        
        return super.canPerformAction(action, withSender: sender)
    }
    
}
