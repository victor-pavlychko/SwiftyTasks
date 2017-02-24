//
//  ProgressLink.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 2/15/17.
//  Copyright © 2017 address.wtf. All rights reserved.
//

import Foundation

/// <#Description#>
internal final class ProgressLink: NSObject {
    
    private let _child: Progress
    private let _proxy: Progress
    private let _lock = NSLock()
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - parent: <#parent description#>
    ///   - child: <#child description#>
    ///   - unitCount: <#parentUnitCount description#>
    internal init(parent: Progress, child: Progress, unitCount: Int64 = 100) {
        _child = child
        _proxy = Progress.discreteProgress(totalUnitCount: 0)
        super.init()

        _lock.sync {
            _child.addOwner(paused: false)

            _proxy.isCancellable = _child.isCancellable
            _proxy.isPausable = _child.isPausable
            _proxy.totalUnitCount = _child.totalUnitCount
            _proxy.completedUnitCount = _child.completedUnitCount

            _proxy.cancellationHandler = { [weak self] in self?._child.cancelByOwner() }
            _proxy.pausingHandler = { [weak self] in self?._child.pauseByOwner() }
            _proxy.resumingHandler = { [weak self] in self?._child.resumeByOwner() }
            _child.addObserver(self, forKeyPath: #keyPath(Progress.totalUnitCount), options: [], context: nil)
            _child.addObserver(self, forKeyPath: #keyPath(Progress.completedUnitCount), options: [], context: nil)
        }

        parent.totalUnitCount += unitCount
        parent.addChild(_proxy, withPendingUnitCount: unitCount)
    }
    
    deinit {
        _child.removeObserver(self, forKeyPath: #keyPath(Progress.totalUnitCount))
        _child.removeObserver(self, forKeyPath: #keyPath(Progress.completedUnitCount))
    }
    
    internal override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        _lock.sync {
            switch keyPath {
            case .some(#keyPath(Progress.totalUnitCount)):
                _proxy.totalUnitCount = _child.totalUnitCount
            case .some(#keyPath(Progress.completedUnitCount)):
                _proxy.completedUnitCount = _child.completedUnitCount
            default:
                break
            }
        }
    }
}
