//
//  ImageLoopView.swift
//  QuickBuild
//
//  Created by lyj on 10/10/2016.
//  Copyright © 2016 heronlyj. All rights reserved.
//

import UIKit
import NotificationCenter

class ImageLoopViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleBackgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
}

/**
 * ImageLoopViewDelegate
 */
public protocol ImageLoopViewDelegate: class {
    
    /// 需要显示的个数
    var dataSourceCount: Int { get }
    
    /// 是否隐藏 title
    var titleIsHidden: Bool { get }
    
    /// 针对特定 cell 定制停留时间
    ///
    /// - parameter index: 下标
    func stopTimeInteval(at index: Int) -> TimeInterval
    
    /// 当前显示的 cell
    ///
    /// - parameter view:       ImageLoopView
    /// - parameter index:      current index
    /// - parameter imageView:  current imageView
    /// - parameter titleLabel: current label
    func loopView(_ view: ImageLoopView, loopAt index: Int, imageView: UIImageView, titleLabel: UILabel)
    
    /**
     图片点击的回调事件
     
     - parameter scrollView:   ImageLoopView
     - parameter tapImageView: 点击的图片
     - parameter atIndex:      当前点击的下标
     */
    func loopView(_ view: ImageLoopView, tapAt index: Int)
}

public class ImageLoopView: UIView {
    
    public var collectionView: UICollectionView!
    fileprivate var flowLayout: UICollectionViewFlowLayout!
    
    public weak var delegate: ImageLoopViewDelegate? {
        didSet {
            setUpTimer()
            collectionView.reloadData()
        }
    }
    
    fileprivate var timer: Timer?
    fileprivate let multipleNumber = 10000
    fileprivate var autoLoop: Bool = true
    
    fileprivate var scrollTimeInterval: TimeInterval = 4.0
    
    /// 从中间开始滚动
    fileprivate var startItem: Int {
        return totalCount > 1 ? totalCount / 2 : 0
    }
    
    fileprivate var totalCount: Int {
        guard let delegate = delegate else { return 0 }
        return delegate.dataSourceCount > 1 ? delegate.dataSourceCount * multipleNumber : delegate.dataSourceCount
    }
    
    public convenience init(frame: CGRect, autoLoop: Bool) {
        self.init(frame: frame)
        self.autoLoop = autoLoop
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        
        flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = .zero
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = .leastNonzeroMagnitude
        flowLayout.minimumInteritemSpacing = .leastNonzeroMagnitude
        
        collectionView = UICollectionView(frame: bounds, collectionViewLayout: flowLayout)
        
        let bundle = Bundle(for: ImageLoopViewCell.self)
        let nib = UINib(nibName: ImageLoopViewCell.reuseId, bundle: bundle)
        collectionView.register(nib, forCellWithReuseIdentifier: ImageLoopViewCell.reuseId)
        
        collectionView.backgroundColor = UIColor.clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.isPagingEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        
        addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraint(NSLayoutConstraint(item: collectionView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: collectionView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: collectionView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: collectionView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0))
        
        scrollCollectionView()
        setUpTimer()
        
        NotificationCenter.default.addObserver(forName: .UIDeviceOrientationDidChange, object: nil, queue: .main) { [weak self] (_) in
            self?.collectionView.reloadData()
        }
    }
    
    
    
}

extension ImageLoopView: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalCount
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withType: ImageLoopViewCell.self, for: indexPath)!
        let currentindex = getCurrentIndex(indexPath: indexPath)
        cell.titleLabel.isHidden = delegate?.titleIsHidden ?? true
        cell.titleBackgroundView.isHidden = delegate?.titleIsHidden ?? true
        delegate?.loopView(self, loopAt: currentindex, imageView: cell.imageView, titleLabel: cell.titleLabel)
        return cell
    }
    
    //换算当前 实际的下标
    func getCurrentIndex(indexPath: IndexPath) -> Int {
        return totalCount > 1 ? indexPath.item % (totalCount / multipleNumber) : indexPath.row
    }
    
}

extension ImageLoopView: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let currentIndex = getCurrentIndex(indexPath: indexPath)
        delegate?.loopView(self, tapAt: currentIndex)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return bounds.size
    }

}

//MARK: - timer
extension ImageLoopView {
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        killTimer()
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        setUpTimer()
    }
    
    func setUpTimer() {
        
        killTimer()
        
        // 定制停留时间
        var stopTime = scrollTimeInterval
        
        if let index = collectionView.indexPathsForVisibleItems.first {
            let currentIndex = getCurrentIndex(indexPath: index)
            stopTime = delegate?.stopTimeInteval(at: currentIndex) ?? scrollTimeInterval
        }
        
        if totalCount > 1 && autoLoop {
            
            timer = Timer.after(stopTime, { [weak self] in
                
                guard
                    let strongSelf = self,
                    let currentIndex = strongSelf.collectionView.indexPathsForVisibleItems.first?.item
                    else { return }

                var targetIndex = currentIndex + 1
                
                if targetIndex % 100 == 0 {
                    targetIndex = strongSelf.totalCount / 2
                    strongSelf.collectionView.scrollToItem(at: IndexPath(item: targetIndex - 1, section: 0), at: .centeredHorizontally, animated: false)
                }
                
                strongSelf.collectionView.scrollToItem(at: IndexPath(item: targetIndex, section: 0), at: .centeredHorizontally, animated: true)
                strongSelf.setUpTimer()
            })
        }
    }
    
    func killTimer() {
        if timer != nil {
            timer!.invalidate()
            timer = nil
        }
    }
    
    /**
     初始化的时候，将 collectionView 定位到 totalCount 中间的位置
     */
    func scrollCollectionView() {
        collectionView.reloadData()
        if totalCount > 1 {
            let indexPath = IndexPath(item: totalCount / 2, section: 0)
            collectionView.scrollToItem(at: indexPath, at: [], animated: false)
        }
    }
    
}
