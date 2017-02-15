//
//  Chaining.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 9/23/16.
//  Copyright © 2016 address.wtf. All rights reserved.
//

import Foundation

/// Attach dependency to a `Task`
///
/// - Parameters:
///   - lhs: task
///   - rhs: dependency task
/// - Returns: `lhs` task
public func ~~ <T, U> (lhs: T, rhs: U) -> T where T: AnyTask, U: AnyTask {
    for operation in lhs.backingOperations {
        for dependency in rhs.backingOperations {
            operation.addDependency(dependency)
            Progress.connect(progressReporting: operation, addDependency: dependency)
        }
    }
    return lhs
}

/// Attach dependencies to a `Task`
///
/// - Parameters:
///   - lhs: task
///   - rhs: dependency tasks
/// - Returns: `lhs` task
public func ~~ <T, S> (lhs: T, rhs: S) -> T where T: AnyTask, S: Sequence, S.Iterator.Element == AnyTask {
    for operation in lhs.backingOperations {
        for dependencyTask in rhs {
            for dependency in dependencyTask.backingOperations {
                operation.addDependency(dependency)
                Progress.connect(progressReporting: operation, addDependency: dependency)
            }
        }
    }
    return lhs
}
