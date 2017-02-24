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

    private let _taskType: Any.Type
    private weak var _task: AnyTask<ResultType>?
    
    public init<T>(_ factory: @escaping () throws -> T) where T: TaskProtocol, T.ResultType == ResultType {
        _taskType = T.self
        _factory = { try AnyTask(factory()) }
    }
    
    /// <#Description#>
    public override func main() {
        do {
            let task = try _factory()
            _task = task
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
    public override var description: String {
        let address = Unmanaged.passUnretained(self).toOpaque()
        if let task = _task {
            return "<\(String(describing: type(of: self))): \(address), \(task)>"
        } else {
            return "<\(String(describing: type(of: self))): \(address), \(String(describing: _taskType))>"
        }
    }
}
