//
//  CompoundProgressExtensions.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 2/28/17.
//  Copyright © 2017 address.wtf. All rights reserved.
//

import Foundation

fileprivate let _globalLock = NSLock()

fileprivate struct AssociatedKeys {
    fileprivate struct CompoundProgressReporting {
        fileprivate static var compoundProgress = "SwiftyTasks.CompoundProgressReporting.compoundProgress"
    }
}

public extension CompoundProgressReporting {
    
    var compoundProgress: Progress {
        if let compoundProgress = objc_getAssociatedObject(self, &AssociatedKeys.CompoundProgressReporting.compoundProgress) as? Progress {
            return compoundProgress
        }
        return _globalLock.sync {
            if let compoundProgress = objc_getAssociatedObject(self, &AssociatedKeys.CompoundProgressReporting.compoundProgress) as? Progress {
                return compoundProgress
            }
            let compoundProgress = _makeCompoundProgress()
            objc_setAssociatedObject(self, &AssociatedKeys.CompoundProgressReporting.compoundProgress, compoundProgress, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return compoundProgress
        }
    }
    
    private func _makeCompoundProgress() -> Progress {
        let compoundProgress = Progress(discreteUnitCount: 0, label: "Compound progress for \(self)")
        compoundProgress.isCancellable = true
        compoundProgress.isPausable = true
        _attachSelfComponent(to: compoundProgress)
        return compoundProgress
    }
    
    private func _attachSelfComponent(to progress: Progress) {
        if let component = self as? WeightenedProgressReporting {
            compoundProgress.addComponent(progress: component.progress, unitCount: component.progressWeight.rawValue)
        } else if let component = self as? ProgressReporting {
            compoundProgress.addComponent(progress: component.progress, unitCount: ProgressWeight.default.rawValue)
        }
    }
}

extension Operation: CompoundProgressReporting { }
