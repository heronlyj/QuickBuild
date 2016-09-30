//
//  Random.swift
//  QuickBuild
//
//  Created by lyj on 21/09/2016.
//  Copyright © 2016 heronlyj. All rights reserved.
//

import Foundation

/**
 *  生成随机数
 */

public protocol RandomAble {
    func randomInRange(_ range: Range<Int>) -> Int
}

extension RandomAble {
    public func randomInRange(_ range: Range<Int>) -> Int {
        let count = UInt32(range.upperBound - range.lowerBound)
        return  Int(arc4random_uniform(count)) + range.lowerBound
    }
}

extension Int: RandomAble {
    
    public var randomizer: [Int] {
        let max = self
        let sum = randomInRange(Range(0...max))
        var indexArray = [Int]()
        repeat {
            if indexArray.count == sum { break }
            let i = randomInRange(0..<max)
            if indexArray.contains(i) {
                continue
            } else {
                indexArray.append(i)
            }
        } while true
        return indexArray
    }
    
    public var randomInt: Int {
        return randomInRange(Range(0...self))
    }
    
}


extension Array: RandomAble {
    
    public var randomizer: [Element] {
        return self[count.randomizer.sorted()]
    }
    
    public var randomElement: Element {
        return self[randomInRange(0..<count)]
    }
    
    public subscript(input: [Int]) -> [Element] {
        get {
            var result = [Element]()
            for i in input {
                assert(i < self.count, "Index out of range")
                result.append(self[i])
            }
            return result
        }
        
        set {
            for (index,i) in input.enumerated() {
                assert(i < self.count, "Index out of range")
                self[i] = newValue[index]
            }
        }
    }
    
}
