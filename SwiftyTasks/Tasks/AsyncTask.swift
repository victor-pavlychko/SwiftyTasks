//
//  AsyncTask.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 9/12/16.
//  Copyright © 2016 address.wtf. All rights reserved.
//

import Foundation

/// Internal data structure to store async Operation state
///
/// - created:   Task has not yet started,    isExecutiong = false, isFinished = false
/// - executing: Task is currently executing, isExecutiong = true,  isFinished = false
/// - finished:  Task has finished,           isExecutiong = false, isFinished = true
fileprivate enum AsyncTaskState {
    case created
    case executing
    case finished
    
    /// returns KVO keyPath to be notified for specified state
    var keyPath: String? {
        switch self {
        case .created: return nil
        case .executing: return "isExecuting"
        case .finished: return "isFinished"
        }
    }
}

/// Base class for writing custom async Tasks. Extenda `Task` class
/// with asynchronous `Operation` state handling.
open class AsyncTask<ResultType>: Task<ResultType> {
    
    private var _state: AsyncTaskState = .created {
        willSet {
            guard _state != newValue else {
                return
            }

            _state.keyPath.flatMap(self.willChangeValue(forKey:))
            newValue.keyPath.flatMap(self.willChangeValue(forKey:))
        }
        didSet {
            guard _state != oldValue else {
                return
            }

            _state.keyPath.flatMap(self.didChangeValue(forKey:))
            oldValue.keyPath.flatMap(self.didChangeValue(forKey:))
        }
    }

    public final override var isConcurrent: Bool { return true }
    public final override var isAsynchronous: Bool { return true }
    public final override var isExecuting: Bool { return _state == .executing }
    public final override var isFinished: Bool { return _state == .finished }

    public override class var progressWeight: ProgressWeight { return .normal }

    open override func start() {
        _state = .executing
        purgeDependencies()
        guard !isCancelled else {
            finish(error: TaskError.cancelled)
            return
        }
        main()
    }

    internal override func _finish() {
        super._finish()
        _state = .finished
    }
}
