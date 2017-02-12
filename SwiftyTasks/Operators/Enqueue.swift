//
//  Enqueue.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 9/18/16.
//  Copyright © 2016 address.wtf. All rights reserved.
//

import Foundation

/// Enqueue `Task` onto `OpetaitonQueue` and return it back
///
/// - Parameters:
///   - lhs: target queue
///   - rhs: task
/// - Returns: `rhs` task
@discardableResult
public func += <T> (lhs: OperationQueue, rhs: T) -> T where T: AnyTask {
    lhs.addOperations(rhs.backingOperations, waitUntilFinished: false)
    return rhs
}
