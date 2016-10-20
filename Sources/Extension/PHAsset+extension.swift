//
//  PHAsset+extension.swift
//  QuickBuild
//
//  Created by lyj on 18/10/2016.
//  Copyright © 2016 heronlyj. All rights reserved.
//

import UIKit
import Photos


public extension PHAsset {
    
    public func fetchImage(_ complete: @escaping (UIImage?) -> Void) {
        let option = PHImageRequestOptions()
        option.resizeMode = .fast
        option.deliveryMode = .highQualityFormat
        
        PHImageManager.default().requestImage(
            for         : self,
            targetSize  : Screen.size,
            contentMode : .aspectFill,
            options     : option)
        { (image: UIImage?, info: [AnyHashable: Any]?) in
            complete(image)
        }
    }
    
}
