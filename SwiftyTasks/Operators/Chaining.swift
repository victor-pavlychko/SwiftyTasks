//
//  Chaining.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 9/23/16.
//  Copyright © 2016 address.wtf. All rights reserved.
//

import Foundation

/// <#Description#>
///
/// - parameter lhs: <#lhs description#>
/// - parameter rhs: <#rhs description#>
///
/// - returns: <#return value description#>
public func ~~ <T: Operation, U: Operation> (lhs: T, rhs: U) -> T {
    lhs.addDependency(rhs)
    return lhs
}

/// <#Description#>
///
/// - parameter lhs: <#lhs description#>
/// - parameter rhs: <#rhs description#>
///
/// - returns: <#return value description#>
public func ~~ <T: Operation, U: AnyTask> (lhs: T, rhs: U) -> T {
    rhs.backingOperations.forEach(lhs.addDependency)
    return lhs
}

/// <#Description#>
///
/// - parameter lhs: <#lhs description#>
/// - parameter rhs: <#rhs description#>
///
/// - returns: <#return value description#>
public func ~~ <T: AnyTask, U: Operation> (lhs: T, rhs: U) -> T {
    lhs.backingOperations.forEach {
        $0.addDependency(rhs)
    }
    return lhs
}

/// <#Description#>
///
/// - parameter lhs: <#lhs description#>
/// - parameter rhs: <#rhs description#>
///
/// - returns: <#return value description#>
public func ~~ <T: AnyTask, U: AnyTask> (lhs: T, rhs: U) -> T {
    lhs.backingOperations.forEach {
        rhs.backingOperations.forEach($0.addDependency)
    }
    return lhs
}
