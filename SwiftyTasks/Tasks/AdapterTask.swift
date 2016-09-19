//
//  AdapterTask.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 9/18/16.
//  Copyright © 2016 address.wtf. All rights reserved.
//

import Foundation

public struct AdapterTask<ResultType>: TaskProtocol {
    
    private let _task: AnyTask
    private let _adapter: () throws -> ResultType
    
    public init<P: TaskProtocol>(_ task: P, _ adapter: @escaping () throws -> ResultType) {
        _task = task
        _adapter = adapter
    }
    
    public init<P: TaskProtocol>(_ task: P, _ adapter: @escaping (P.ResultType) throws -> ResultType) {
        _task = task
        _adapter = { return try adapter(task.getResult()) }
    }
    
    public var backingOperation: Operation {
        return _task.backingOperation
    }
    
    public func getResult() throws -> ResultType {
        return try _adapter()
    }
}

public extension TaskProtocol {
    
    public func convert<R>(_ adapter: @escaping () throws -> R) -> AdapterTask<R> {
        return AdapterTask(self, adapter)
    }
    
    public func convert<R>(_ adapter: @escaping (Self.ResultType) throws -> R) -> AdapterTask<R> {
        return AdapterTask(self, adapter)
    }
}
