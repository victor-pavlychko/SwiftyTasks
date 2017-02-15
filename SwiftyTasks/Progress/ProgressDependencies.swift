//
//  ProgressDependencies.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 2/15/17.
//  Copyright © 2017 address.wtf. All rights reserved.
//

import Foundation

fileprivate struct AssociatedKeys {
    fileprivate struct Progress {
        fileprivate static var _ownerCount = "SwiftyTasks.Progress._ownerCount"
        fileprivate static var _pauseCount = "SwiftyTasks.Progress._pauseCount"
        fileprivate static var _cancelCount = "SwiftyTasks.Progress._cancelCount"
    }
}

internal extension Progress {
    
    /// <#Description#>
    private var _ownerCount: Int {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.Progress._ownerCount) as? Int ?? 0 }
        set { objc_setAssociatedObject(self, &AssociatedKeys.Progress._ownerCount, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    /// <#Description#>
    private var _pauseCount: Int {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.Progress._pauseCount) as? Int ?? 0 }
        set { objc_setAssociatedObject(self, &AssociatedKeys.Progress._pauseCount, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    /// <#Description#>
    private var _cancelCount: Int {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.Progress._cancelCount) as? Int ?? 0 }
        set { objc_setAssociatedObject(self, &AssociatedKeys.Progress._cancelCount, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    /// <#Description#>
    private func _handleOwnerState() {
        assert(_pauseCount >= 0 && _pauseCount <= _ownerCount)
        assert(_cancelCount >= 0 && _cancelCount <= _ownerCount)
        guard !isCancelled && !isPrincipal && _ownerCount > 0 else {
            return
        }
        guard _cancelCount < _ownerCount else {
            cancel()
            return
        }
        if isPaused && _pauseCount < _ownerCount {
            resume()
        } else if !isPaused && _pauseCount == _ownerCount {
            pause()
        }
    }
    
    /// <#Description#>
    ///
    /// - Parameter paused: <#paused description#>
    internal func addOwner(paused: Bool) {
        sync {
            _ownerCount += 1
            _pauseCount += paused ? 1 : 0
            _handleOwnerState()
        }
    }
    
    /// <#Description#>
    internal func pauseByOwner() {
        sync {
            _pauseCount += 1
            _handleOwnerState()
        }
    }
    
    /// <#Description#>
    internal func resumeByOwner() {
        sync {
            _pauseCount -= 1
            _handleOwnerState()
        }
    }
    
    /// <#Description#>
    internal func cancelByOwner() {
        sync {
            _cancelCount += 1
            _handleOwnerState()
        }
    }
}
