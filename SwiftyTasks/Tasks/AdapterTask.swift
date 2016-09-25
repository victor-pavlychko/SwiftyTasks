//
//  AdapterTask.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 9/18/16.
//  Copyright © 2016 address.wtf. All rights reserved.
//

import Foundation

/// General-purpose task adapter.
/// This object will start/wait for all backing operations and
/// use provided block to copmute result when requested.
public struct AdapterTask<ResultType>: TaskProtocol {
    
    private let _adapter: () throws -> ResultType

    public let backingOperations: [Operation]
    
    /// Creates adapter with a single backing task
    ///
    /// - parameter task:    backing operation
    /// - parameter adapter: result block
    ///
    /// - returns: newly created adapter
    init(_ task: AnyTask, _ adapter: @escaping () throws -> ResultType) {
        _adapter = adapter
        backingOperations = task.backingOperations
    }
    
    /// Creates adapter with multiple backing tasks
    ///
    /// - parameter tasks:   list of backing operations
    /// - parameter adapter: result block
    ///
    /// - returns: newly created adapter
    init(_ tasks: [AnyTask], _ adapter: @escaping () throws -> ResultType) {
        _adapter = adapter
        backingOperations = tasks.flatMap { $0.backingOperations }
    }
    
    /// Retrieves result of task execution
    ///
    /// - throws: wrapped error if any
    ///
    /// - returns: task result
    public func getResult() throws -> ResultType {
        return try _adapter()
    }
}

public extension TaskProtocol {
    
    /// Converts result of the task using a provided block
    ///
    /// - parameter adapter: adapter block
    ///
    /// - returns: Adapter task wrapping current task
    public func convert<R>(_ adapter: @escaping () throws -> R) -> AdapterTask<R> {
        return AdapterTask(self, adapter)
    }
    
    /// Converts result of the task using a provided block
    ///
    /// - parameter adapter: adapter block
    /// - parameter value:   original task result
    ///
    /// - returns: Adapter task wrapping current task
    public func convert<R>(_ adapter: @escaping (_ value: Self.ResultType) throws -> R) -> AdapterTask<R> {
        return AdapterTask(self, { try adapter(self.getResult()) })
    }
}
