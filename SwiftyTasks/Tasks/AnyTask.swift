//
//  AnyTask.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 2/20/17.
//  Copyright © 2017 address.wtf. All rights reserved.
//

import Foundation

/// <#Description#>
public class AnyTask<T>: TaskProtocol, CustomStringConvertible {
    
    private let _taskBox: _AnyTaskBox<T>
    
    /// <#Description#>
    public typealias ResultType = T
    
    public init<T>(_ task: T) where T: TaskProtocol, T.ResultType == ResultType {
        _taskBox = _AnyTaskBoxImpl(task)
    }
    
    /// <#Description#>
    public var backingOperations: [Operation] {
        return _taskBox.backingOperations
    }
    
    /// <#Description#>
    ///
    /// - Returns: <#return value description#>
    /// - Throws: <#throws value description#>
    public func getResult() throws -> ResultType {
        return try _taskBox.getResult()
    }
    
    /// <#Description#>
    public var description: String {
        let address = Unmanaged.passUnretained(self).toOpaque()
        return "<\(String(describing: type(of: self))): \(address), \(_taskBox)>"
    }
}

fileprivate class _AnyTaskBox<T>: TaskProtocol, CustomStringConvertible {
    
    typealias ResultType = T
    
    var backingOperations: [Operation] {
        fatalError()
    }
    
    func getResult() throws -> ResultType {
        fatalError()
    }
    
    var description: String {
        fatalError()
    }
}

fileprivate class _AnyTaskBoxImpl<T>: _AnyTaskBox<T.ResultType> where T: TaskProtocol {
    
    private let _task: T
    
    init(_ task: T) {
        _task = task
    }
    
    override var backingOperations: [Operation] {
        return _task.backingOperations
    }
    
    override func getResult() throws -> ResultType {
        return try _task.getResult()
    }
    
    override var description: String {
        return String(describing: _task)
    }
}
