//
//  SelectView.swift
//  QuickBuild
//
//  Created by lyj on 22/09/2016.
//  Copyright © 2016 heronlyj. All rights reserved.
//

import UIKit

public protocol SelectViewDelegate: class {
    func didSelect(of bagSelectView: SelectView, at row: Int)
}

public protocol SelectViewDataSource: class {
    var selectStrings: [String] { get }
    func colorConfig(of bagSelectView: SelectView, at row: Int) -> (backgroundColor: UIColor, textColor: UIColor)
}


public class SelectView: NSObject {
    
    public enum Position {
        
        case navLeft(width: CGFloat)
        case navMiddle(width: CGFloat)
        case navRight(width: CGFloat)
        case custom(origin: CGPoint, width: CGFloat)
        
        var startFrame: CGRect {
            
            let space   : CGFloat = 5
            let originY : CGFloat = 64 + 3
            
            // 高度根据 内容来判定
            switch self {
            case .navLeft(let width)     : return CGRect(x: space, y: originY, width: width, height: 0)
            case .navMiddle(let width)   : return CGRect(x: (Screen.width - width)/2, y: originY, width: width, height: 0)
            case .navRight(let width)    : return CGRect(x: Screen.width - width - space, y: originY, width: width, height: 0)
            case .custom(let origin, let width): return CGRect(origin: origin, size: CGSize(width: width, height: 0))
            }
        }
        
    }
    
    
    var contentTableView: UITableView!
    
    public var cornerRadius: CGFloat = 0 {
        didSet {
            self.contentTableView.layer.cornerRadius = cornerRadius
        }
    }
    
    public var isShow: Bool = false
    
    public var cellHeight: CGFloat = 50
    public var startAlpha: CGFloat = 0.9
    public var startFrame: CGRect = CGRect.zero
    
    public weak var delegate: SelectViewDelegate? {
        didSet {
            contentTableView.reloadData()
        }
    }
    
    public weak var dataSource: SelectViewDataSource? {
        didSet {
            contentTableView.reloadData()
        }
    }
    
    private override init() {}
    
    public convenience init(inView: UIView, position: Position) {
        self.init()
        
        startFrame = position.startFrame
        contentTableView = UITableView(frame: startFrame, style: .plain)
        contentTableView.frame.size.height = 0
        
        contentTableView.register(UITableViewCell.self, forCellReuseIdentifier: "SelectViewCell")
        contentTableView.tableFooterView = UIView()
        contentTableView.delegate = self
        contentTableView.dataSource = self
        contentTableView.isHidden = true
        contentTableView.alpha = startAlpha
        
        inView.addSubview(contentTableView)
    }
    
    public func refreshDataSource() {
        contentTableView.reloadData()
    }
    
    public func show() {
        
        guard let count = dataSource?.selectStrings.count else { return }
        
        // 最多显示 6 条数据，多余的得滚动
        let showHeight: CGFloat = count > 6 ? 6.5 * cellHeight : count.cgFloat * cellHeight
        
        self.contentTableView.alpha = startAlpha
        self.contentTableView.isHidden = false
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.4, options: .curveEaseInOut, animations: { 
            self.contentTableView.frame.size.height = showHeight
            }, completion: { _ in
            self.isShow = true
        })
    }
    
    public func hidden() {
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.4, options: .curveEaseInOut, animations: {
            self.contentTableView.frame.size.height = 0
            self.contentTableView.alpha = 0
        }){ (finish) in
            self.contentTableView.isHidden = true
            self.isShow = false
        }
        
    }
    
    public func changeStatus() {
        if isShow {
            hidden()
        } else {
            show()
        }
    }
    
}


extension SelectView: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dataSource = dataSource else { return 0 }
        return dataSource.selectStrings.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectViewCell", for: indexPath)
        
        if let dataSource = dataSource {
            
            let configColor = dataSource.colorConfig(of: self, at: indexPath.row)
            
            cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.text = dataSource.selectStrings[indexPath.row]
            cell.textLabel?.textColor = configColor.textColor
            
            cell.backgroundColor = configColor.backgroundColor
            tableView.backgroundColor = configColor.backgroundColor
        }
        
        return cell
    }
    
}

extension SelectView: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let delegate = delegate {
            delegate.didSelect(of: self, at: indexPath.row)
        }
        
        hidden()
    }
    
}



/**
 *  能选择学校列表的协议
 */
//protocol SelectClassAble: BagSelectViewDataSource, BagSelectViewDelegate, ClassNameViewDelegate {
//    var classNames: [ClassModel] { get }
//    var selectView: BagSelectView? { get }
//}


//// MARK: - 能选择学校列表的 ViewController 的默认实现
//extension SelectClassAble where Self: UIViewController {
//    
//    var classNames: [ClassModel] {
//        
//        let realm = try! Realm()
//        guard let roleModel = getRoleModel(UserCenter.roleItem.value?.roleId, realm: realm) else { return [] }
//        return roleModel.classList.map{ $0 }
//        
//    }
//    
//    var selectStrings: [String] {
//        return classNames.map { $0.cname }
//    }
//    
//    func colorConfig(of bagSelectView: BagSelectView, at row: Int) -> (backgroundColor: UIColor, textColor: UIColor) {
//        return (backgroundColor: bagBasicColor, textColor: .whiteColor())
//    }
//    
//    func classNameViewTap() {
//        
//        if let hidden = selectView?.contentTableView.hidden where hidden {
//            self.selectView?.show()
//        } else {
//            self.selectView?.hidden()
//        }
//        
//    }
//    
//}


