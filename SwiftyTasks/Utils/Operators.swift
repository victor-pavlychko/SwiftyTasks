//
//  Operators.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 9/12/16.
//  Copyright © 2016 address.wtf. All rights reserved.
//

import Foundation

infix operator =>

// MARK: - Object setup -

func => <T> (lhs: T, rhs: (T) -> Void) -> T {
    rhs(lhs)
    return lhs
}

func => <T, U> (lhs: T, rhs: (T) -> U) -> U {
    return rhs(lhs)
}

func with<R, T0>(_ a0: T0, _ code: (T0) throws -> R) rethrows -> R {
    return try code(a0)
}

func with<R, T0, T1>(_ a0: T0, _ a1: T1, _ code: (T0, T1) throws -> R) rethrows -> R {
    return try code(a0, a1)
}

func with<R, T0, T1, T2>(_ a0: T0, _ a1: T1, _ a2: T2, _ code: (T0, T1, T2) throws -> R) rethrows -> R {
    return try code(a0, a1, a2)
}
