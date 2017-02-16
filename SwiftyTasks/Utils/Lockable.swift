//
//  Lockable.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 9/30/16.
//  Copyright © 2016 address.wtf. All rights reserved.
//

import Foundation

internal extension DispatchSemaphore {

    /// Synchronizes block execution on a `DispatchSemaphore` and waits until that block completes.
    ///
    /// - Parameter block: The block to be executed
    /// - Returns: Block execution result
    /// - Throws: Rethrows block error
    @inline(__always)
    internal func sync<T>(execute block: () throws -> T) rethrows -> T {
        wait()
        defer { signal() }
        return try block()
    }
}

internal extension NSLocking {
    
    /// Synchronizes block execution on an `NSLock` and waits until that block completes.
    ///
    /// - Parameter block: The block to be executed
    /// - Returns: Block execution result
    /// - Throws: Rethrows block error
    @inline(__always)
    internal func sync<T>(execute block: () throws -> T) rethrows -> T {
        lock()
        defer { unlock() }
        return try block()
    }
    
    @inline(__always)
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - variable: <#variable description#>
    ///   - value: <#value description#>
    ///   - block: <#block description#>
    /// - Throws: <#throws value description#>
    internal func syncAndSet<T>(variable: inout T, value: T, execute block: () throws -> Void) rethrows where T: Equatable {
        try sync {
            if variable != value {
                variable = value
                try block()
            }
        }
    }
}

internal extension Synchronizable {
    
    /// <#Description#>
    ///
    /// - Parameter code: <#code description#>
    /// - Returns: <#return value description#>
    /// - Throws: <#throws value description#>
    @inline(__always)
    internal func sync<T>(_ code: () throws -> T) rethrows -> T {
        return try lock.sync {
            return try code()
        }
    }
}
