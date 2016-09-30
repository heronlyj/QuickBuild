//
//  Docker.swift
//  QuickBuild
//
//  Created by lyj on 21/09/2016.
//  Copyright © 2016 heronlyj. All rights reserved.
//

import Foundation

public class Docker<T> {
    public var value: T
    public init(value: T) {
        self.value = value
    }
}
