//
//  ProgressOwnership.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 2/15/17.
//  Copyright © 2017 address.wtf. All rights reserved.
//

import Foundation

fileprivate let _globalLock = NSLock()

fileprivate extension ProgressUserInfoKey {
    fileprivate static let extraKey = ProgressUserInfoKey(rawValue: "SwiftyTasks.ProgressUserInfoKey.extraKey")
}

fileprivate class ProgressExtra {
    fileprivate var isPrincipal: Bool = false
    fileprivate var interestLevel: Int32 = 0
    fileprivate var executeLevel: Int32 = 0
}

public extension Progress {
    
    private var _extra: ProgressExtra {
        if let extra = userInfo[.extraKey] as? ProgressExtra {
            return extra
        }
        return _globalLock.sync {
            if let extra = userInfo[.extraKey] as? ProgressExtra {
                return extra
            }
            let extra = ProgressExtra()
            setUserInfoObject(extra, forKey: .extraKey)
            return extra
        }
    }
    
    internal func addOwner() {
        OSAtomicIncrement32(&_extra.interestLevel)
        OSAtomicIncrement32(&_extra.executeLevel)
    }
    
    internal func cancelByOwner() {
        if OSAtomicDecrement32(&_extra.interestLevel) == 0 && !isCancelled && !isPrincipal {
            cancel()
        }
    }
    
    internal func pauseByOwner() {
        if OSAtomicDecrement32(&_extra.executeLevel) == 0 && !isCancelled && !isPrincipal {
            pause()
        }
    }
    
    internal func resumeByOwner() {
        if OSAtomicIncrement32(&_extra.executeLevel) == 1 && !isCancelled && !isPrincipal {
            resume()
        }
    }
    
    public func becomePrincipal() {
        _extra.isPrincipal = true
    }
    
    public var isPrincipal: Bool {
        return _extra.isPrincipal
    }
}
