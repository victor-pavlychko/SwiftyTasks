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
public func += <T: AnyTask> (lhs: OperationQueue, rhs: T) -> T {
    rhs.backingOperations.forEach { operation in
        lhs.addOperation(operation)
    }

    return rhs
}
