//
//  CompoundProgressReporting.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 2/24/17.
//  Copyright © 2017 address.wtf. All rights reserved.
//

import Foundation

public protocol CompoundProgressReporting {

    var compoundProgress: Progress { get }
}

fileprivate let _globalLock = NSLock()

fileprivate struct AssociatedKeys {
    fileprivate struct CompoundProgressReporting {
        fileprivate static var compoundProgress = "SwiftyTasks.CompoundProgressReporting.compoundProgress"
    }
}

public extension CompoundProgressReporting where Self: AnyObject {
    
    var compoundProgress: Progress {
        if let compoundProgress = objc_getAssociatedObject(self, &AssociatedKeys.CompoundProgressReporting.compoundProgress) as? Progress {
            return compoundProgress
        }
        return _globalLock.sync {
            if let compoundProgress = objc_getAssociatedObject(self, &AssociatedKeys.CompoundProgressReporting.compoundProgress) as? Progress {
                return compoundProgress
            }

            let compoundProgress = Progress.discreteProgress(totalUnitCount: 0)
            compoundProgress.isCancellable = true
            compoundProgress.isPausable = true

            if let weightenedProgressReporting = self as? WeightenedProgressReporting {
                compoundProgress.addDependency(weightenedProgressReporting.progress, unitCount: weightenedProgressReporting.progressWight.rawValue)
            } else if let progressReporting = self as? ProgressReporting {
                compoundProgress.addDependency(progressReporting.progress, unitCount: ProgressWeight.default.rawValue)
            }

            objc_setAssociatedObject(self, &AssociatedKeys.CompoundProgressReporting.compoundProgress, compoundProgress, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return compoundProgress
        }
    }
}

extension Operation: CompoundProgressReporting { }
