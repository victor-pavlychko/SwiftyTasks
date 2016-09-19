//
//  AdapterTask.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 9/18/16.
//  Copyright © 2016 address.wtf. All rights reserved.
//

import Foundation

/// <#Description#>
public struct AdapterTask<ResultType>: TaskProtocol {
    
    private let _task: AnyTask
    private let _adapter: () throws -> ResultType
    
    /// <#Description#>
    ///
    /// - parameter task:    <#task description#>
    /// - parameter adapter: <#adapter description#>
    ///
    /// - returns: <#return value description#>
    init<P: TaskProtocol>(_ task: P, _ adapter: @escaping () throws -> ResultType) {
        _task = task
        _adapter = adapter
    }
    
    /// <#Description#>
    ///
    /// - parameter task:    <#task description#>
    /// - parameter adapter: <#adapter description#>
    ///
    /// - returns: <#return value description#>
    init<P: TaskProtocol>(_ task: P, _ adapter: @escaping (P.ResultType) throws -> ResultType) {
        _task = task
        _adapter = { return try adapter(task.getResult()) }
    }
    
    /// <#Description#>
    public var backingOperation: Operation {
        return _task.backingOperation
    }
    
    /// <#Description#>
    ///
    /// - throws: <#throws value description#>
    ///
    /// - returns: <#return value description#>
    public func getResult() throws -> ResultType {
        return try _adapter()
    }
}

public extension TaskProtocol {
    
    /// <#Description#>
    ///
    /// - parameter adapter: <#adapter description#>
    ///
    /// - returns: <#return value description#>
    public func convert<R>(_ adapter: @escaping () throws -> R) -> AdapterTask<R> {
        return AdapterTask(self, adapter)
    }
    
    /// <#Description#>
    ///
    /// - parameter adapter: <#adapter description#>
    ///
    /// - returns: <#return value description#>
    public func convert<R>(_ adapter: @escaping (Self.ResultType) throws -> R) -> AdapterTask<R> {
        return AdapterTask(self, adapter)
    }
}
