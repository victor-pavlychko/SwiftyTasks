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
    lhs.backingOperations.forEach { operation in
        rhs.backingOperations.forEach { dependency in
            operation.addDependency(dependency)
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
    lhs.backingOperations.forEach { operation in
        rhs.forEach { dependencyTask in
            dependencyTask.backingOperations.forEach { dependencyOperation in
                operation.addDependency(dependencyOperation)
            }
        }
    }

    return lhs
}
