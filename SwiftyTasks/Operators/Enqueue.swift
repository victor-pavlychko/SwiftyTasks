//
//  Enqueue.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 9/18/16.
//  Copyright © 2016 address.wtf. All rights reserved.
//

import Foundation

/// Enqueue `Operation` onto `OpetaitonQueue` and return it back
///
/// - parameter lhs: target queue
/// - parameter rhs: operation
///
/// - returns: `rhs` operation
public func += <T: Operation> (lhs: OperationQueue, rhs: T) -> T {
    lhs.addOperation(rhs)
    return rhs
}

/// Enqueue `Task` onto `OpetaitonQueue` and return it back
///
/// - parameter lhs: target queue
/// - parameter rhs: task
///
/// - returns: `rhs` task
public func += <T: AnyTask> (lhs: OperationQueue, rhs: T) -> T {
    rhs.backingOperations.forEach(lhs.addOperation)
    return rhs
}
