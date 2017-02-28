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
public func ~~ <T, U> (lhs: T, rhs: U) -> T where T: AnyTaskProtocol, U: AnyTaskProtocol {
    for operation in lhs.backingOperations {
        for dependency in rhs.backingOperations {
            operation.addDependency(dependency)
            operation.attachProgress(component: dependency)
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
public func ~~ <T, S> (lhs: T, rhs: S) -> T where T: AnyTaskProtocol, S: Sequence, S.Iterator.Element == AnyTaskProtocol {
    for operation in lhs.backingOperations {
        for dependencyTask in rhs {
            for dependency in dependencyTask.backingOperations {
                operation.addDependency(dependency)
                operation.attachProgress(component: dependency)
            }
        }
    }
    return lhs
}
