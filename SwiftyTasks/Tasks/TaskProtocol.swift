//
//  TaskProtocol.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 9/15/16.
//  Copyright © 2016 address.wtf. All rights reserved.
//

import Foundation

/// Abstract task
public protocol AnyTask {

    /// List of backing operations
    var backingOperations: [Operation] { get }
}

/// Abstract task with result
public protocol TaskProtocol: AnyTask {

    associatedtype ResultType

    /// Retrieves tast execution result or error
    ///
    /// - Throws: captured error if any
    /// - Returns: execution result
    func getResult() throws -> ResultType
}

extension Operation: AnyTask {
    
    /// List of backing operations which is equal to `[self]` in case of Operation
    public var backingOperations: [Operation] {
        return [self]
    }
}

public extension AnyTask {

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

        var counter: Int32 = Int32(backingOperations.count)
        let countdownBlock = {
            if (OSAtomicDecrement32Barrier(&counter) == 0) {
                completionBlock()
            }
        }

        for operation in backingOperations {
            operation.completionBlock = countdownBlock
            operation.start()
        }
    }
}

public extension TaskProtocol {

    /// Starts execution of all backing operation and fires completion block when ready.
    /// Async operations will run concurrently in background, sync ones will execute one by one
    /// in current thread.
    ///
    /// - Parameters:
    ///   - completionBlock: Completion block to be fired when everyhting is done
    ///   - resultBlock:     Result block wrapping task outcome
    public func start(_ completionBlock: @escaping (_ resultBlock: () throws -> ResultType) -> Void) {
        start { completionBlock(self.getResult) }
    }
}
