//
//  TaskProtocol.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 9/15/16.
//  Copyright © 2016 address.wtf. All rights reserved.
//

import Foundation

/// Abstract task with result
public protocol TaskProtocol: AnyTaskProtocol {

    associatedtype ResultType

    /// Retrieves tast execution result or error
    ///
    /// - Throws: captured error if any
    /// - Returns: execution result
    func getResult() throws -> ResultType
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
