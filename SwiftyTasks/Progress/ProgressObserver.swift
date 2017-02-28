//
//  ProgressObserver.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 2/16/17.
//  Copyright © 2017 address.wtf. All rights reserved.
//

import Foundation

public protocol ProgressObserverListener: class {
    func progress(_ progress: Progress, didUpdateFractionCompleted fractionCompleted: Double)
    func progress(_ progress: Progress, didUpdateUnitCount totalUnitCount: Int64, completedCount completedUnitCount: Int64)
}

public extension ProgressObserverListener {
    func progress(_ progress: Progress, didUpdateFractionCompleted fractionCompleted: Double) { }
    func progress(_ progress: Progress, didUpdateUnitCount totalUnitCount: Int64, completedCount completedUnitCount: Int64) { }
}

public final class ProgressObserver: NSObject {
    
    public let progress: Progress

    public weak var listener: ProgressObserverListener?
    public var progressHandler: ((_ totalUnitCount: Int64, _ compeletedUnitCount: Int64, _ fractionCompleted: Double) -> Void)?
    
    public init(_ progress: Progress) {
        self.progress = progress
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
            let totalUnitCount = progress.totalUnitCount
            let completedUnitCount = progress.completedUnitCount
            let fractionCompleted = progress.fractionCompleted
            DispatchQueue.main.async {
                self.listener?.progress(self.progress, didUpdateFractionCompleted: fractionCompleted)
                self.progressHandler?(totalUnitCount, completedUnitCount, fractionCompleted)
            }
        case .some(#keyPath(Progress.totalUnitCount)), .some(#keyPath(Progress.completedUnitCount)):
            let totalUnitCount = progress.totalUnitCount
            let completedUnitCount = progress.completedUnitCount
            let fractionCompleted = progress.fractionCompleted
            DispatchQueue.main.async {
                self.listener?.progress(self.progress, didUpdateUnitCount: totalUnitCount, completedCount: completedUnitCount)
                self.progressHandler?(totalUnitCount, completedUnitCount, fractionCompleted)
            }
        default:
            break
        }
    }
}
