//
//  TaskOperators.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 9/18/16.
//  Copyright © 2016 address.wtf. All rights reserved.
//

import Foundation

precedencegroup PartialApplicationPrecedence {
    associativity: left
    higherThan: AssignmentPrecedence
    lowerThan: TernaryPrecedence
}

/// Partial application operator
///
/// - Parameters:
///   - lhs: Function
///   - rhs: Argument
/// - Returns: `lhs` with first argument bound to `rhs`
infix operator <~ : PartialApplicationPrecedence

/// Add dependency operator
///
/// - Parameters:
///   - lhs: Dependent Operation
///   - rhs: Dependency Operation
/// - Returns: `lhs`
infix operator ~~ : PartialApplicationPrecedence

// We do not define `~>` operator because stdlib aready did that for it's weird reasons...
#if false

precedencegroup ReverseApplicationPrecedence {
    associativity: left
    higherThan: PartialApplicationPrecedence
}

/// Application operator
///
/// - Parameters:
///   - lhs: Argument tuple
///   - rhs: Function
/// - Returns: `rhs` with arguments bound to `lhs`
infix operator ~> : ReverseApplicationPrecedence

#endif
