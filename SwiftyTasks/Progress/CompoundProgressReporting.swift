//
//  CompoundProgressReporting.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 2/24/17.
//  Copyright © 2017 address.wtf. All rights reserved.
//

import Foundation

public protocol CompoundProgressReporting: class {

    var compoundProgress: Progress { get }
}

public extension CompoundProgressReporting {
    
    public func attachProgress(component: CompoundProgressReporting) {
        compoundProgress.addComponent(progress: component.compoundProgress, unitCount: component.compoundProgress.totalUnitCount)
    }
    
    public func attachProgress(_ progress: Progress, unitCount: Int64 = ProgressWeight.default.rawValue) {
        compoundProgress.addComponent(progress: progress, unitCount: unitCount)
    }
}
