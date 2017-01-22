//
//  OperationExtensions.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 9/12/16.
//  Copyright © 2016 address.wtf. All rights reserved.
//

import Foundation

internal extension Operation {
    
    /// Removes all depencencies attached to this Operations
    internal func purgeDependencies() {
        dependencies.forEach(removeDependency)
    }
    
    /// Bulk add dependencies
    ///
    /// - Parameter ops: list of dependencies to add
    internal func addDependencies<S: Sequence>(_ ops: S) where S.Iterator.Element: Operation {
        ops.forEach(addDependency)
    }

    /// Bulk remove dependencies
    ///
    /// - Parameter ops: list of dependencies to add
    internal func removeDependencies<S: Sequence>(_ ops: S) where S.Iterator.Element: Operation {
        ops.forEach(removeDependency)
    }
}

internal extension OperationQueue {
    
    internal static let serviceQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = Int.max
        return queue
    }()
}
