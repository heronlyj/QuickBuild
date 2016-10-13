//
//  Bundle+extension.swift
//  QuickBuild
//
//  Created by lyj on 13/10/2016.
//  Copyright © 2016 heronlyj. All rights reserved.
//

import Foundation

extension Bundle {
    
    static var resourcesBundle: Bundle? {
        let frameworkBundle = Bundle(for: ImageCollectionView.self)
        guard
            let path = frameworkBundle.url(forResource: "QuickBuildBundle", withExtension: "bundle")
            else { return nil }
        return Bundle(url: path)
    }
    
}
