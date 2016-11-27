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
public func ~~ <T: AnyTask, U: AnyTask> (lhs: T, rhs: U) -> T {
    lhs.backingOperations.forEach { operation in
        rhs.backingOperations.forEach { dependency in
            operation.addDependency(dependency)
        }
    }

    return lhs
}
