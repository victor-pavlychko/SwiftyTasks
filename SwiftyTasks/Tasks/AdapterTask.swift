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
    
    private let _tasks: [AnyTask]
    private let _adapter: () throws -> ResultType
    
    /// <#Description#>
    ///
    /// - parameter task:    <#task description#>
    /// - parameter adapter: <#adapter description#>
    ///
    /// - returns: <#return value description#>
    init(_ task: AnyTask, _ adapter: @escaping () throws -> ResultType) {
        _tasks = [task]
        _adapter = adapter
    }
    
    /// <#Description#>
    ///
    /// - parameter task:    <#task description#>
    /// - parameter adapter: <#adapter description#>
    ///
    /// - returns: <#return value description#>
    init(_ tasks: [AnyTask], _ adapter: @escaping () throws -> ResultType) {
        _tasks = tasks
        _adapter = adapter
    }
    
    /// <#Description#>
    public var backingOperations: [Operation] {
        return _tasks.flatMap { $0.backingOperations }
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
        return AdapterTask(self, { try adapter(self.getResult()) })
    }
}
