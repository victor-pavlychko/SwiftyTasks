//
//  Synchronizable.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 2/15/17.
//  Copyright © 2017 address.wtf. All rights reserved.
//

import Foundation

fileprivate let _globalLock = NSLock()

fileprivate struct AssociatedKeys {
    fileprivate struct Synchronizable {
        fileprivate static var _lock = "SwiftyTasks.Synchronizable._lock"
    }
}

/// <#Description#>
internal protocol Synchronizable: class {

    /// <#Description#>
    var lock: NSLock { get }
}

internal extension Synchronizable {
    
    /// <#Description#>
    internal var lock: NSLock {
        if let lock = objc_getAssociatedObject(self, &AssociatedKeys.Synchronizable._lock) as? NSLock {
            return lock
        }
        return _globalLock.sync {
            if let lock = objc_getAssociatedObject(self, &AssociatedKeys.Synchronizable._lock) as? NSLock {
                return lock
            }
            let lock = NSLock()
            objc_setAssociatedObject(self, &AssociatedKeys.Synchronizable._lock, lock, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return lock
        }
    }
}

extension Progress: Synchronizable { }
