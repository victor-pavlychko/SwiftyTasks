//
//  Enqueue.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 9/18/16.
//  Copyright © 2016 address.wtf. All rights reserved.
//

import Foundation

/// <#Description#>
///
/// - parameter lhs: <#lhs description#>
/// - parameter rhs: <#rhs description#>
///
/// - returns: <#return value description#>
public func += <T: Operation> (lhs: OperationQueue, rhs: T) -> T {
    lhs.addOperation(rhs)
    return rhs
}

/// <#Description#>
///
/// - parameter lhs: <#lhs description#>
/// - parameter rhs: <#rhs description#>
///
/// - returns: <#return value description#>
public func += <T: AnyTask> (lhs: OperationQueue, rhs: T) -> T {
    rhs.backingOperations.forEach(lhs.addOperation)
    return rhs
}
