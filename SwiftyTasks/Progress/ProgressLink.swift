//
//  ProgressLink.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 2/15/17.
//  Copyright © 2017 address.wtf. All rights reserved.
//

import Foundation

fileprivate let kTotalUnitCountKey = "totalUnitCount"
fileprivate let kCompletedUnitCountKey = "fractionCompleted"

/// <#Description#>
internal final class ProgressLink: NSObject {
    
    private weak var _parent: Progress?
    private let _child: Progress
    private let _proxy = Progress.discreteProgress(totalUnitCount: 0)
    private let _lock = NSLock()
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - parent: <#parent description#>
    ///   - child: <#child description#>
    ///   - parentUnitCount: <#parentUnitCount description#>
    internal init(parent: Progress, child: Progress, parentUnitCount: Int64 = 1) {
        _parent = parent
        _child = child
        super.init()

        _child.addOwner(paused: false)

        _proxy.cancellationHandler = { [weak self] in self?._child.cancelByOwner() }
        _proxy.pausingHandler = { [weak self] in self?._child.pauseByOwner() }
        _proxy.resumingHandler = { [weak self] in self?._child.resumeByOwner() }

        _lock.sync {
            _child.addObserver(self, forKeyPath: kTotalUnitCountKey, options: [], context: nil)
            _child.addObserver(self, forKeyPath: kCompletedUnitCountKey, options: [], context: nil)
            _proxy.totalUnitCount = _child.totalUnitCount
            _proxy.completedUnitCount = _child.completedUnitCount
        }
        
        _parent?.totalUnitCount += parentUnitCount
        _parent?.addChild(_proxy, withPendingUnitCount: parentUnitCount)
    }
    
    deinit {
        _child.removeObserver(self, forKeyPath: kTotalUnitCountKey)
        _child.removeObserver(self, forKeyPath: kCompletedUnitCountKey)
    }
    
    internal override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        _lock.sync {
            switch keyPath {
            case .some(kTotalUnitCountKey):
                _proxy.totalUnitCount = _child.totalUnitCount
            case .some(kCompletedUnitCountKey):
                _proxy.completedUnitCount = _child.completedUnitCount
            default:
                break
            }
        }
    }
}
