//
//  PageView.swift
//  QuickBuild
//
//  Created by lyj on 27/09/2016.
//  Copyright © 2016 heronlyj. All rights reserved.
//

import UIKit

public protocol PageViewDelegate: class {
    func pageView(view: PageView, scrollAt index: Int)
}

public class PageView: UIView {
    
    public weak var delegate: PageViewDelegate?
    
    public var titleIsShow = true
    public var flagViewIsShow = false
    
    /// 设置颜色
    public var titleColor: UIColor = .black
    public var titleSelectedColor: UIColor = .gray
    public var titleBackgroundColor: UIColor = .white
    public var titleSelectedBackgroundColor: UIColor = .darkGray
    
    public var flagViewColor: UIColor = .red
    
    public var titleScrollViewHeight: CGFloat = 53
    
    public var titleButtonWidth: CGFloat?
    
    var selectedButton: UIButton?
    
    var flagView: UIView!
    var titleScrollView: UIScrollView!
    var contentScrollView: UIScrollView!
    
    var titles = [String]()
    var views = [UIView]()
    var viewControllers = [UIViewController]()
    
    public convenience init(frame: CGRect, titles: [String], views: [UIView]) {
        self.init(frame: frame)
        
        guard titles.count == views.count else {
            fatalError("Initilization failed, the titles array count does not match the views array count.")
        }
        
        self.titles = titles
        self.views = views
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func initBaseView() {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let titleButtonWidth: CGFloat = self.titleButtonWidth == nil ? titles.count < 6 ? frame.width/CGFloat(titles.count) : 60 : self.titleButtonWidth!
        
        flagView = {
            let view = UIView(frame: CGRect(x: 0, y: titleScrollViewHeight - 3, width: titleButtonWidth, height: 3))
            view.backgroundColor = .red
            return view
        }()
        
        titleScrollView = {
            
            let frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.titleScrollViewHeight)
            let scrollView = UIScrollView(frame: frame)
            scrollView.delegate = self
            scrollView.bounces = false
            scrollView.backgroundColor = .white
            scrollView.isDirectionalLockEnabled = true
            scrollView.showsVerticalScrollIndicator = false
            scrollView.showsHorizontalScrollIndicator = false
            
            scrollView.contentSize = CGSize(width: titleButtonWidth * CGFloat(self.titles.count), height: self.titleScrollViewHeight)
            
            for i in 0..<titles.count {
                
                let button = UIButton(type: .custom)
                button.backgroundColor = .white
                button.tag = 100 + i
                button.isSelected = i == 0
                button.setTitle(titles[i], for: .normal)
                button.setTitleColor(titleColor, for: .normal)
                button.setTitleColor(titleSelectedColor, for: .selected)
                button.addTarget(self, action: #selector(titleButtonTap(btn:)), for: .touchUpInside)
                button.frame = CGRect(x: CGFloat(i) * titleButtonWidth, y: 0, width: titleButtonWidth, height: self.titleScrollViewHeight)
                
                printLogDebug(button.frame)
                
                if button.isSelected {
                    selectedButton = button
                    button.backgroundColor = titleSelectedBackgroundColor
                }
                
                scrollView.addSubview(button)
            }
            
            return scrollView
        }()
        
        if titleIsShow {
            addSubview(titleScrollView)
        }
        
        if titleIsShow && flagViewIsShow {
            addSubview(flagView)
        }
        
        contentScrollView = {
            
            let frame = CGRect(
                x: 0,
                y: self.titleIsShow ? self.titleScrollViewHeight : 0,
                width: self.frame.width,
                height: self.titleIsShow ? self.frame.height - self.titleScrollViewHeight : self.frame.height
            )
            
            let scrollView = UIScrollView(frame: frame)
            scrollView.delegate = self
            scrollView.bounces = false
            scrollView.isPagingEnabled = true
            scrollView.isDirectionalLockEnabled = true
            scrollView.showsVerticalScrollIndicator = false
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.contentSize = CGSize(width: frame.width * CGFloat(self.titles.count), height: frame.height)
            
            for (index, view) in views.enumerated() {
                view.frame = CGRect(x: CGFloat(index) * frame.width, y: 0, width: frame.width, height: frame.height)
                scrollView.addSubview(view)
            }
            
            return scrollView
        }()
        
        addSubview(contentScrollView)
    }
    
    
    @objc private func titleButtonTap(btn: UIButton) {
        
        if selectedButton != nil {
            selectedButton?.isSelected = false
            selectedButton?.backgroundColor = titleBackgroundColor
        }
        
        btn.isSelected = true
        btn.backgroundColor = titleSelectedBackgroundColor
        selectedButton = btn
        
        let index = btn.tag - 100
        contentScrollView.setContentOffset(CGPoint(x: self.frame.width * CGFloat(index), y: 0), animated: true)
    }
}

extension PageView: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        printLogDebug(titleScrollView.subviews)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView === contentScrollView {
            let index = scrollView.contentOffset.x / scrollView.frame.width
            delegate?.pageView(view: self, scrollAt: Int(index))
            
            UIView.animate(withDuration: 0.2, animations: {
                self.flagView.frame.origin.x = self.titleScrollView.contentOffset.x * index
            })
        }
    }
    
}
