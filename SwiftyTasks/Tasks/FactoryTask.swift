//
//  FactoryTask.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 2/8/17.
//  Copyright © 2017 address.wtf. All rights reserved.
//

import Foundation

/// <#Description#>
public final class FactoryTask<ResultType>: AsyncTask<ResultType> {
    
    private let _lock = NSLock()
    private var _factory: () throws -> AnyTask<ResultType>
    private var _task: AnyTask<ResultType>?
    
    public init<T>(_ factory: @escaping () throws -> T) where T: TaskProtocol, T.ResultType == ResultType {
        _factory = { try AnyTask(factory()) }
    }

    /// <#Description#>
    public override func handleCancelled() {
        super.handleCancelled()
        _lock.sync {
            _task?.cancel()
        }
    }
    
    /// <#Description#>
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

    /// <#Description#>
    ///
    /// - Returns: <#return value description#>
    /// - Throws: <#throws value description#>
    private func makeTask() throws -> AnyTask<ResultType> {
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
