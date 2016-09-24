//
//  Chaining.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 9/23/16.
//  Copyright © 2016 address.wtf. All rights reserved.
//

import Foundation

/// Attach dependency to an `Operation`
///
/// - parameter lhs: operation
/// - parameter rhs: dependency operation
///
/// - returns: `lhs` operation
public func ~~ <T: Operation, U: Operation> (lhs: T, rhs: U) -> T {
    lhs.addDependency(rhs)
    return lhs
}

/// Attach dependency to an `Operation`
///
/// - parameter lhs: operation
/// - parameter rhs: dependency task
///
/// - returns: `lhs` operation
public func ~~ <T: Operation, U: AnyTask> (lhs: T, rhs: U) -> T {
    rhs.backingOperations.forEach(lhs.addDependency)
    return lhs
}

/// Attach dependency to a `Task`
///
/// - parameter lhs: task
/// - parameter rhs: dependency operation
///
/// - returns: `lhs` task
public func ~~ <T: AnyTask, U: Operation> (lhs: T, rhs: U) -> T {
    lhs.backingOperations.forEach {
        $0.addDependency(rhs)
    }
    return lhs
}

/// Attach dependency to a `Task`
///
/// - parameter lhs: task
/// - parameter rhs: dependency task
///
/// - returns: `lhs` task
public func ~~ <T: AnyTask, U: AnyTask> (lhs: T, rhs: U) -> T {
    lhs.backingOperations.forEach {
        rhs.backingOperations.forEach($0.addDependency)
    }
    return lhs
}
