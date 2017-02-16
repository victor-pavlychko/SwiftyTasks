//
//  FactoryTask.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 2/8/17.
//  Copyright © 2017 address.wtf. All rights reserved.
//

import Foundation

public final class FactoryTask<ResultType>: AsyncTask<ResultType> {
    
    private let _lock = NSLock()
    private var _factory: () throws -> AnyTaskBox<ResultType>
    private var _task: AnyTaskBox<ResultType>?
    
    public init<T>(_ factory: @escaping () throws -> T) where T: TaskProtocol, T.ResultType == ResultType {
        _factory = { try AnyTaskBox(factory()) }
    }

    public override func handleCancelled() {
        super.handleCancelled()
        _lock.sync {
            _task?.cancel()
        }
    }
    
    public override func main() {
        do {
            let task = try makeTask()
            for operation in task.backingOperations {
                progress.addDependency(operation.operationProgress)
            }
            task.start {
                self.finish(task.getResult)
            }
        } catch {
            finish(error: error)
        }
    }

    private func makeTask() throws -> AnyTaskBox<ResultType> {
        return try _lock.sync {
            guard !isCancelled else {
                throw TaskError.cancelled
            }
            let task = try _factory()
            _task = task
            return task
        }
    }
}

public class AnyTaskBox<T>: TaskProtocol {
    
    private let _taskBox: _AnyTaskBox<T>
    
    public typealias ResultType = T
    
    public init<T>(_ task: T) where T: TaskProtocol, T.ResultType == ResultType {
        _taskBox = _AnyTaskBoxImpl(task)
    }
    
    public var backingOperations: [Operation] {
        return _taskBox.backingOperations
    }
    
    public func getResult() throws -> ResultType {
        return try _taskBox.getResult()
    }
}

fileprivate class _AnyTaskBox<T>: TaskProtocol {
    
    typealias ResultType = T

    var backingOperations: [Operation] {
        fatalError()
    }

    func getResult() throws -> ResultType {
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
}
