//
//  UIImage+extension.swift
//  QuickBuild
//
//  Created by lyj on 11/10/2016.
//  Copyright © 2016 heronlyj. All rights reserved.
//

import UIKit
import Photos

public extension UIImage {
    
    public static func drawImage(size: CGSize, color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        color.set()
        UIRectFill(CGRect(origin: CGPoint.zero, size: size))
        guard let colorImage = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()
        return colorImage
    }
    
}


public struct ImageAssetItem {
    public var url: String?
    public var name: String?
    public var image: UIImage?
    public var asset: PHAsset?
    
    public init(url: String? = nil, name: String? = nil, image: UIImage? = nil, asset: PHAsset? = nil) {
        self.url = url
        self.name = name
        self.image = image
        self.asset = asset
    }
    
    public func assetSource(placeHolder: String = "", roundCorner: Bool = false) -> ImageAssetSource? {
        if let name = name {
            return ImageAssetSource.name(name: name)
        }
        if let url = url {
            return ImageAssetSource.urlStr(urlStr: url, placeHolder: placeHolder, roundCorner: roundCorner)
        }
        if let image = image {
            return ImageAssetSource.image(image: image)
        }
        if let asset = asset {
            return ImageAssetSource.asset(asset: asset)
        }
        return nil
    }
}

public enum ImageAssetSource {
    case name(name: String)
    case asset(asset: PHAsset)
    case image(image: UIImage)
    case urlStr(urlStr: String, placeHolder: String, roundCorner: Bool)
}
