//
//  Inetrested.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 2/8/17.
//  Copyright © 2017 address.wtf. All rights reserved.
//

import Foundation

public protocol Interested: class {
    func addInterest(_ interest: Interest)
    func abandonInterests()
}

fileprivate let _lock = NSLock()

fileprivate struct AssociatedKeys {
    fileprivate struct Interested {
        fileprivate static var _interests = "SwiftyTasks.Interested._interests"
    }
}

public extension Interested {
    
    private var _interests: NSMutableSet {
        if let interests = objc_getAssociatedObject(self, &AssociatedKeys.Interested._interests) as? NSMutableSet {
            return interests
        }
        let interests = NSMutableSet()
        objc_setAssociatedObject(self, &AssociatedKeys.Interested._interests, interests, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return interests
    }
    
    public func addInterest(_ interest: Interest) {
        _lock.sync {
            _interests.add(interest)
        }
    }
    
    public func abandonInterests() {
        _lock.sync {
            _interests.removeAllObjects()
        }
    }
}

extension Operation: Interested { }
