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
    func sync<T>(execute block: () throws -> T) rethrows -> T {
        wait()
        defer { signal() }
        return try block()
    }
}

internal extension NSLock {
    
    /// Synchronizes block execution on an `NSLock` and waits until that block completes.
    ///
    /// - Parameter block: The block to be executed
    /// - Returns: Block execution result
    /// - Throws: Rethrows block error
    func sync<T>(execute block: () throws -> T) rethrows -> T {
        lock()
        defer { unlock() }
        return try block()
    }
}

internal extension NSCondition {
    
    /// Synchronizes block execution on an `NSCondition` and waits until that block completes.
    ///
    /// - Parameter block: The block to be executed
    /// - Returns: Block execution result
    /// - Throws: Rethrows block error
    func sync<T>(execute block: () throws -> T) rethrows -> T {
        lock()
        defer { unlock() }
        return try block()
    }
}
