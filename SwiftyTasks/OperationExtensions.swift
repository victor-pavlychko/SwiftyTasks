//
//  OperationExtensions.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 9/12/16.
//  Copyright © 2016 address.wtf. All rights reserved.
//

import Foundation

public extension Operation {
    
    /// Removes all depencencies attached to this Operations
    public func purgeDependencies() {
        dependencies.forEach(removeDependency)
    }
    
    /// Bulk add dependencies
    ///
    /// - parameter ops: list of dependencies to add
    public func addDependencies<S: Sequence>(_ ops: S) where S.Iterator.Element: Operation {
        ops.forEach(addDependency)
    }

    /// Bulk remove dependencies
    ///
    /// - parameter ops: list of dependencies to add
    public func removeDependencies<S: Sequence>(_ ops: S) where S.Iterator.Element: Operation {
        ops.forEach(removeDependency)
    }
}
