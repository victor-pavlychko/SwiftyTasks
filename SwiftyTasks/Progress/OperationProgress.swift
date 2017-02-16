//
//  OperationProgress.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 2/17/17.
//  Copyright © 2017 address.wtf. All rights reserved.
//

import Foundation

fileprivate let _globalLock = NSLock()

fileprivate struct AssociatedKeys {
    fileprivate struct Operation {
        fileprivate static var operationProgress = "SwiftyTasks.Operation.operationProgress"
    }
}

internal extension Operation {

    /// <#Description#>
    internal var operationProgress: Progress {
        if let progressReporting = self as? ProgressReporting {
            return progressReporting.progress
        }
        if let operationProgress = objc_getAssociatedObject(self, &AssociatedKeys.Operation.operationProgress) as? Progress {
            return operationProgress
        }
        return _globalLock.sync {
            if let operationProgress = objc_getAssociatedObject(self, &AssociatedKeys.Operation.operationProgress) as? Progress {
                return operationProgress
            }
            let operationProgress = Progress.discreteProgress(totalUnitCount: -1)
            operationProgress.isCancellable = true
            operationProgress.cancellationHandler = { [weak self] in self?.cancel() }
            OperationQueue.serviceQueue += BlockTask { operationProgress.complete() } ~~ self
            objc_setAssociatedObject(self, &AssociatedKeys.Operation.operationProgress, operationProgress, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return operationProgress
        }
    }
}
