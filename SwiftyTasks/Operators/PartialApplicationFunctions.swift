//
//  PartialApplication.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 9/18/16.
//  Copyright © 2016 address.wtf. All rights reserved.
//

import Foundation

// MARK: function + value, non-throwing

public func <~ <R, T0> (fn: @escaping (T0) -> R, args: T0) -> R {
    return fn(args)
}

public func <~ <R, T0, T1> (fn: @escaping (T0, T1) -> R, args: T0) -> (T1) -> R {
    return { a1 in fn(args, a1) }
}

public func <~ <R, T0, T1, T2> (fn: @escaping (T0, T1, T2) -> R, args: T0) -> (T1, T2) -> R {
    return { a1, a2 in fn(args, a1, a2) }
}

// MARK: function + value, throwing

public func <~ <R, T0> (fn: @escaping (T0) throws -> R, args: T0) throws -> R {
    return try fn(args)
}

public func <~ <R, T0, T1> (fn: @escaping (T0, T1) throws -> R, args: T0) -> (T1) throws -> R {
    return { a1 in try fn(args, a1) }
}

public func <~ <R, T0, T1, T2> (fn: @escaping (T0, T1, T2) throws -> R, args: T0) -> (T1, T2) throws -> R {
    return { a1, a2 in try fn(args, a1, a2) }
}
