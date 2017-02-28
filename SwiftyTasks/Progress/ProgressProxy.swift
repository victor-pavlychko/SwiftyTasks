//
//  ProgressProxy.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 2/15/17.
//  Copyright © 2017 address.wtf. All rights reserved.
//

import Foundation

internal final class ProgressProxy: Progress {

    private let _underlying: Progress

    internal init(_ underlying: Progress) {
        _underlying = underlying
        super.init(parent: nil)

        cancellationHandler = { [weak self] in self?._underlying.cancelByOwner() }
        pausingHandler = { [weak self] in self?._underlying.pauseByOwner() }
        resumingHandler = { [weak self] in self?._underlying.resumeByOwner() }

        _underlying.addOwner()
        _underlying.addObserver(self, forKeyPath: #keyPath(Progress.isCancellable), options: [.initial], context: nil)
        _underlying.addObserver(self, forKeyPath: #keyPath(Progress.isPausable), options: [.initial], context: nil)
        _underlying.addObserver(self, forKeyPath: #keyPath(Progress.totalUnitCount), options: [.initial], context: nil)
        _underlying.addObserver(self, forKeyPath: #keyPath(Progress.completedUnitCount), options: [.initial], context: nil)
        _underlying.addObserver(self, forKeyPath: #keyPath(Progress.fractionCompleted), options: [.initial], context: nil)
    }
    
    deinit {
        _underlying.removeObserver(self, forKeyPath: #keyPath(Progress.isCancellable))
        _underlying.removeObserver(self, forKeyPath: #keyPath(Progress.isPausable))
        _underlying.removeObserver(self, forKeyPath: #keyPath(Progress.totalUnitCount))
        _underlying.removeObserver(self, forKeyPath: #keyPath(Progress.completedUnitCount))
        _underlying.removeObserver(self, forKeyPath: #keyPath(Progress.fractionCompleted))
    }
    
    internal override var description: String {
        return _underlying.description
    }
    
    internal override var debugDescription: String {
        return _underlying.debugDescription
    }
    
    internal override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        switch keyPath {
        case .some(#keyPath(Progress.isCancellable)):
            isCancellable = _underlying.isCancellable
        case .some(#keyPath(Progress.isPausable)):
            isPausable = _underlying.isPausable
        case .some(#keyPath(Progress.totalUnitCount)):
            totalUnitCount = _underlying.totalUnitCount
        case .some(#keyPath(Progress.completedUnitCount)), .some(#keyPath(Progress.fractionCompleted)):
            completedUnitCount = _calculateCompletedUnitCount(_underlying)
        default:
            break
        }
    }
    
    private func _calculateCompletedUnitCount(_ progress: Progress) -> Int64 {
        let totalUnitCount = progress.totalUnitCount
        let realCompletedUnitCount = progress.completedUnitCount
        let approximateCompletedUnitCount = Int64((Double(progress.totalUnitCount) * progress.fractionCompleted).rounded())
        return min(totalUnitCount, max(realCompletedUnitCount, approximateCompletedUnitCount))
    }
}
