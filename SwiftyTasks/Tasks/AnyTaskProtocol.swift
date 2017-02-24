//
//  AnyTaskProtocol.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 2/20/17.
//  Copyright © 2017 address.wtf. All rights reserved.
//

import Foundation

/// Abstract task
public protocol AnyTaskProtocol {
    
    /// List of backing operations
    var backingOperations: [Operation] { get }
}

public extension AnyTaskProtocol {
    
    /// Starts execution of all backing operation and fires completion block when ready.
    /// Async operations will run concurrently in background, sync ones will execute one by one
    /// in current thread.
    ///
    /// - Parameter completionBlock: Completion block to be fired when everyhting is done
    public func start(_ completionBlock: @escaping () -> Void) {
        guard !backingOperations.isEmpty else {
            completionBlock()
            return
        }

        OperationQueue.serviceQueue += self

        let operationFinalizer = BlockOperation { completionBlock() }
        operationFinalizer.addDependencies(backingOperations)
        OperationQueue.serviceQueue += operationFinalizer
    }
}

extension Operation: AnyTaskProtocol {
    
    /// List of backing operations which is equal to `[self]` in case of Operation
    public var backingOperations: [Operation] {
        return [self]
    }
}
