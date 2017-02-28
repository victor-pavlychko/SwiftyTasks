//
//  FactoryTask.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 2/8/17.
//  Copyright © 2017 address.wtf. All rights reserved.
//

import Foundation

public final class FactoryTask<TaskType>: AsyncTask<TaskType.ResultType> where TaskType: TaskProtocol {

    private let _lock = NSLock()
    private var _factory: () throws -> TaskType
    private weak var _task: TaskType?
    
    public override class var progressWeight: ProgressWeight {
        if let weightenedProgressReporting = TaskType.self as? WeightenedProgressReporting.Type {
            return weightenedProgressReporting.progressWeight
        }
        return .default
    }
    
    public init(_ factory: @escaping () throws -> TaskType) {
        _factory = factory
    }
    
    public override func main() {
        do {
            let task = try _factory()
            _task = task
            for operation in task.backingOperations {
                attachProgress(component: operation)
            }
            task.start {
                self.finish(task.getResult)
            }
        } catch {
            finish(error: error)
        }
    }

    public override var description: String {
        let address = Unmanaged.passUnretained(self).toOpaque()
        if let task = _task {
            return "<\(String(describing: type(of: self))): \(address), \(task)>"
        } else {
            return "<\(String(describing: type(of: self))): \(address), \(String(describing: TaskType.self))>"
        }
    }
}
