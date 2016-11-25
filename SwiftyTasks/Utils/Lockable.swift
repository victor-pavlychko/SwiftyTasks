//
//  Lockable.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 9/30/16.
//  Copyright © 2016 address.wtf. All rights reserved.
//

import Foundation

internal extension DispatchSemaphore {

    func sync<T>(execute block: () throws -> T) rethrows -> T {
        wait()
        defer { signal() }
        return try block()
    }
}

internal extension NSLock {
    
    func sync<T>(execute block: () throws -> T) rethrows -> T {
        lock()
        defer { unlock() }
        return try block()
    }
}

internal extension NSCondition {
    
    func sync<T>(execute block: () throws -> T) rethrows -> T {
        lock()
        defer { unlock() }
        return try block()
    }
}
