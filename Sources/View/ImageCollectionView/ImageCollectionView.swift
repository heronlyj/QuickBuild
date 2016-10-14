//
//  PictureCollectionView.swift
//  zhysq
//
//  Created by lyj on 08/10/2016.
//  Copyright © 2016 heronlyj. All rights reserved.
//

import UIKit

public protocol ImageCollectionViewDelegate: class {
    
    /// 数据的总数
    var datesNumber: Int { get }
    
    /// 显示模式的默认图片
    var selectModelDefaultImage: UIImage? { get }
    
    /// 需要自己实现 设置 cell imageView.image 的代理
    ///
    /// - parameter imageView: cell.imageView
    /// - parameter indexPath: cell.indexPath
    ///
    func imageView(_ imageView: UIImageView, willShowAt indexPath: IndexPath)
    
    func collectionView(_ collectionView: ImageCollectionView, didSelectedAt indexPath: IndexPath, removeComplete: (Bool) -> Void)
    
}

public class ImageCollectionView: UICollectionView {
    
    public var isShowModel: Bool = false
    
    fileprivate var itemCount: Int {
        return imageDelegate?.datesNumber ?? 0
    }
    
    public static var itemSize: CGSize = {
        // 考虑到屏幕旋转，因此需要保持 cell 的宽度
        let itemHeight = min(Screen.width, Screen.height)/4
        return CGSize(width: itemHeight, height: itemHeight)
    }()
    
    // collectionView 全部显示的高度，内嵌在 tableViewCell 中动态计算 cell 高度使用
    public static func height(boundsWidth: CGFloat, datasNumber count: Int, isShowModel: Bool) -> CGFloat {
        // 每行的个数
        let countPerRow = Int(boundsWidth/ImageCollectionView.itemSize.width)
        // 共有多少个 cell
        let itemCount = count + (isShowModel ? 0 : 1)
        // 共有多少行
        let row = (itemCount / countPerRow) + (itemCount % countPerRow == 0 ? 0 : 1)
        
        return CGFloat(row) * ImageCollectionView.itemSize.height
    }
    
    public weak var imageDelegate: ImageCollectionViewDelegate?
    
    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {
        
        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.itemSize = ImageCollectionView.itemSize
            flowLayout.minimumLineSpacing = .leastNonzeroMagnitude
            flowLayout.minimumInteritemSpacing = .leastNonzeroMagnitude
        }
        
        register(name: ImageCollectionViewCell.reuseId, in: Bundle(for: ImageCollectionView.self))
        
        bounces = false
        delegate = self
        dataSource = self
        isScrollEnabled = false
    }
    
}

extension ImageCollectionView: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isShowModel ? itemCount : itemCount + 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withType: ImageCollectionViewCell.self, for: indexPath)!
        
        if indexPath.item == itemCount {
            cell.xImageView.isHidden = true
            cell.imageView.image = imageDelegate?.selectModelDefaultImage ?? UIImage(named: "add", in: Bundle.resourcesBundle, compatibleWith: nil)
        } else {
            cell.xImageView.isHidden = isShowModel
            imageDelegate?.imageView(cell.imageView, willShowAt: indexPath)
        }
        
        return cell
    }
    
}

extension ImageCollectionView: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        imageDelegate?.collectionView(self, didSelectedAt: indexPath) { [weak collectionView] finish in
            collectionView?.performBatchUpdates({
                collectionView?.deleteItems(at: [indexPath])
                }, completion: nil)
        }
    }

}

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var xImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        xImageView.image = UIImage(named: "deleteFlag", in: Bundle.resourcesBundle, compatibleWith: nil)
        
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
    }
}

