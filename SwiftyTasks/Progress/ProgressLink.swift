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
    
    public let _child: Progress
    public let _proxy: Progress
    private let _lock = NSLock()
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - parent: <#parent description#>
    ///   - child: <#child description#>
    ///   - unitCount: <#parentUnitCount description#>
    internal init(parent: Progress, child: Progress, unitCount: Int64 = 100) {
        _child = child
        _proxy = Progress(discreteUnitCount: 0, description: "Proxy: \(_child.progressDescription)")
        super.init()

        _lock.sync {
            _child.addOwner(paused: false)

            _proxy.isCancellable = _child.isCancellable
            _proxy.isPausable = _child.isPausable
            _proxy.totalUnitCount = _child.totalUnitCount
            _proxy.completedUnitCount = calculateCompletedUnitCount(_child)

            _proxy.cancellationHandler = { [weak self] in self?._child.cancelByOwner() }
            _proxy.pausingHandler = { [weak self] in self?._child.pauseByOwner() }
            _proxy.resumingHandler = { [weak self] in self?._child.resumeByOwner() }
            _child.addObserver(self, forKeyPath: #keyPath(Progress.totalUnitCount), options: [], context: nil)
            _child.addObserver(self, forKeyPath: #keyPath(Progress.completedUnitCount), options: [], context: nil)
            _child.addObserver(self, forKeyPath: #keyPath(Progress.fractionCompleted), options: [], context: nil)
        }

        parent.totalUnitCount += unitCount
        parent.addChild(_proxy, withPendingUnitCount: unitCount)
    }
    
    deinit {
        _child.removeObserver(self, forKeyPath: #keyPath(Progress.totalUnitCount))
        _child.removeObserver(self, forKeyPath: #keyPath(Progress.completedUnitCount))
        _child.removeObserver(self, forKeyPath: #keyPath(Progress.fractionCompleted))
    }
    
    internal override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        _lock.sync {
            switch keyPath {
            case .some(#keyPath(Progress.totalUnitCount)):
                _proxy.totalUnitCount = _child.totalUnitCount
            case .some(#keyPath(Progress.completedUnitCount)), .some(#keyPath(Progress.fractionCompleted)):
                _proxy.completedUnitCount = calculateCompletedUnitCount(_child)
            default:
                break
            }
        }
    }
    
    private func calculateCompletedUnitCount(_ progress: Progress) -> Int64 {
        let totalUnitCount = progress.totalUnitCount
        let realCompletedUnitCount = progress.completedUnitCount
        let approximateCompletedUnitCount = Int64((Double(progress.totalUnitCount) * progress.fractionCompleted).rounded())
        return min(totalUnitCount, max(realCompletedUnitCount, approximateCompletedUnitCount))
    }
}
