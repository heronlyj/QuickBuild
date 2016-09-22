//
//  ReuseViewCell.swift
//  QuickBuild
//
//  Created by lyj on 21/09/2016.
//  Copyright © 2016 heronlyj. All rights reserved.
//

import Foundation


import UIKit

// UITableViewCell 或者 UICollectionCell 的 ID
public protocol ReuseView {
    static var reuseId: String { get }
}

extension ReuseView {
    
    /// 这里必须是静态方法才可以
    public static var reuseId: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReuseView {}
extension UITableViewHeaderFooterView: ReuseView {}

extension UICollectionReusableView: ReuseView {}

extension UITableView {
    
    public func dequeueReusableCell<T: ReuseView>(withType type: T.Type) -> T? {
        return dequeueReusableCell(withIdentifier: type.reuseId) as? T
    }
    
    public func dequeueReuseableCell<T: ReuseView>(withType type: T.Type, indexPath: IndexPath) -> T? {
        return dequeueReusableCell(withIdentifier: type.reuseId, for: indexPath) as? T
    }
    
    public func dequeueReusableHeaderFooterView<T: ReuseView>(withType type: T.Type) -> T? {
        return dequeueReusableHeaderFooterView(withIdentifier: type.reuseId) as? T
    }
    
    //    func dequeueReusableCellWithCellType<T: UITableViewCell>(cellType: T.Type) -> T? {
    //        return dequeueReusableCellWithIdentifier(String(cellType)) as? T
    //    }
}

extension UICollectionView {
    
    public func dequeueReusableCell<T: ReuseView>(withType type: T.Type, for indexPath: IndexPath) -> T? {
        return dequeueReusableCell(withReuseIdentifier: type.reuseId, for: indexPath) as? T
    }
    
}


/// 便于从 nib 文件初始化的扩展
public protocol RegisterFromNib {
    func register(withNibAndIdName nibAndIdName: String, in bundle: Bundle)
    func register(withNibName nibName: String, id identifier: String, in bundle: Bundle)
}

public extension RegisterFromNib where Self: UITableView {
    
    public func register(withNibName nibName: String, id identifier: String, in bundle: Bundle = Bundle.main) {
        register(UINib(nibName: nibName, bundle: bundle), forCellReuseIdentifier: identifier)
    }
    
    public  func register(withNibAndIdName nibAndIdName: String, in bundle: Bundle = Bundle.main) {
        register(UINib(nibName: nibAndIdName, bundle: bundle), forCellReuseIdentifier: nibAndIdName)
    }
    
}

public enum CollectionSupplementaryViewKind {
    case header, footer
}

public extension RegisterFromNib where Self: UICollectionView {
    
    public func register(withNibName nibName: String, id identifier: String, in bundle: Bundle = Bundle.main) {
        register(UINib(nibName: nibName, bundle: bundle), forCellWithReuseIdentifier: identifier)
    }
    
    public func register(withNibAndIdName nibAndIdName: String, in bundle: Bundle = Bundle.main) {
        register(UINib(nibName: nibAndIdName, bundle: bundle), forCellWithReuseIdentifier: nibAndIdName)
    }
    
    public func register(withNibName nibName: String, id identifier: String, in bundle: Bundle = Bundle.main, for supplementaryViewOfKind: CollectionSupplementaryViewKind) {
        let nib = UINib(nibName: nibName, bundle: bundle)
        
        switch supplementaryViewOfKind {
        case .header:
            register(nib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: identifier)
            
        case .footer:
            register(nib, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: identifier)
        }
    }
    
}

extension UITableView: RegisterFromNib {}
extension UICollectionView: RegisterFromNib {}

