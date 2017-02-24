//
//  ProgressObserver.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 2/16/17.
//  Copyright © 2017 address.wtf. All rights reserved.
//

import Foundation

/// <#Description#>
public protocol ProgressObserverListener: class {

    /// <#Description#>
    ///
    /// - Parameters:
    ///   - progress: <#progress description#>
    ///   - fractionCompleted: <#fractionCompleted description#>
    func progress(_ progress: Progress, didUpdateFractionCompleted fractionCompleted: Double)

    /// <#Description#>
    ///
    /// - Parameters:
    ///   - progress: <#progress description#>
    ///   - totalUnitCount: <#totalUnitCount description#>
    ///   - completedUnitCount: <#completedUnitCount description#>
    func progress(_ progress: Progress, didUpdateUnitCount totalUnitCount: Int64, completedCount completedUnitCount: Int64)
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - progress: <#progress description#>
    ///   - state: <#state description#>
    func progress(_ progress: Progress, didChangeState state: ProgressObserver.State)
}

public extension ProgressObserverListener {
    func progress(_ progress: Progress, didUpdateFractionCompleted fractionCompleted: Double) { }
    func progress(_ progress: Progress, didUpdateUnitCount totalUnitCount: Int64, completedCount completedUnitCount: Int64) { }
}

/// <#Description#>
public final class ProgressObserver: NSObject {
    
    /// <#Description#>
    ///
    /// - active: <#active description#>
    /// - paused: <#paused description#>
    /// - completed: <#completed description#>
    /// - cancelled: <#cancelled description#>
    public enum State {
        case active
        case paused
        case completed
        case cancelled
    }
    
    /// <#Description#>
    public weak var listener: ProgressObserverListener? {
        didSet {
            if let listener = listener {
                listener.progress(progress, didChangeState: state)
                listener.progress(progress, didUpdateFractionCompleted: progress.fractionCompleted)
                listener.progress(progress, didUpdateUnitCount: progress.totalUnitCount, completedCount: progress.completedUnitCount)
            }
        }
    }

    /// <#Description#>
    public var fractionCompletedHandler: ((_ fractionCompleted: Double) -> Void)? {
        didSet {
            fractionCompletedHandler?(progress.fractionCompleted)
        }
    }
    
    /// <#Description#>
    public var unitCountHandler: ((_ totalUnitCount: Int64, _ compeletedUnitCount: Int64) -> Void)? {
        didSet {
            unitCountHandler?(progress.totalUnitCount, progress.completedUnitCount)
        }
    }
    
    /// <#Description#>
    public var stateHandler: ((_ state: State) -> Void)? {
        didSet {
            stateHandler?(state)
        }
    }

    /// <#Description#>
    public let progress: Progress
    
    /// <#Description#>
    public var state: State {
        if progress.totalUnitCount == progress.completedUnitCount {
            return .completed
        }
        if progress.isCancelled {
            return .cancelled
        }
        if progress.isPaused {
            return .paused
        }
        return .active
    }

    /// <#Description#>
    ///
    /// - Parameters:
    ///   - progress: <#progress description#>
    ///   - listener: <#listener description#>
    public init(_ progress: Progress, listener: ProgressObserverListener? = nil) {
        self.progress = progress
        self.listener = listener
        super.init()

        progress.addObserver(self, forKeyPath: #keyPath(Progress.fractionCompleted), options: [], context: nil)
        progress.addObserver(self, forKeyPath: #keyPath(Progress.totalUnitCount), options: [], context: nil)
        progress.addObserver(self, forKeyPath: #keyPath(Progress.completedUnitCount), options: [], context: nil)
        progress.addObserver(self, forKeyPath: #keyPath(Progress.isPaused), options: [], context: nil)
        progress.addObserver(self, forKeyPath: #keyPath(Progress.isCancelled), options: [], context: nil)
    }
    
    deinit {
        progress.removeObserver(self, forKeyPath: #keyPath(Progress.fractionCompleted))
        progress.removeObserver(self, forKeyPath: #keyPath(Progress.totalUnitCount))
        progress.removeObserver(self, forKeyPath: #keyPath(Progress.completedUnitCount))
        progress.removeObserver(self, forKeyPath: #keyPath(Progress.isPaused))
        progress.removeObserver(self, forKeyPath: #keyPath(Progress.isCancelled))
    }
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        switch keyPath {
        case .some(#keyPath(Progress.fractionCompleted)):
            let fractionCompleted = progress.fractionCompleted
            DispatchQueue.main.async {
                self.listener?.progress(self.progress, didUpdateFractionCompleted: fractionCompleted)
                self.fractionCompletedHandler?(fractionCompleted)
            }
        case .some(#keyPath(Progress.totalUnitCount)), .some(#keyPath(Progress.completedUnitCount)):
            let totalUnitCount = progress.totalUnitCount
            let completedUnitCount = progress.completedUnitCount
            DispatchQueue.main.async {
                self.listener?.progress(self.progress, didUpdateUnitCount: totalUnitCount, completedCount: completedUnitCount)
                self.unitCountHandler?(totalUnitCount, completedUnitCount)
            }
        case .some(#keyPath(Progress.isPaused)), .some(#keyPath(Progress.isCancelled)):
            let state = self.state
            DispatchQueue.main.async {
                self.listener?.progress(self.progress, didChangeState: state)
                self.stateHandler?(state)
            }
        default:
            break
        }
    }
}
