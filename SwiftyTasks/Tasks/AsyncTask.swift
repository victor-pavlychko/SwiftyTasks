//
//  AsyncTask.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 9/12/16.
//  Copyright © 2016 address.wtf. All rights reserved.
//

import Foundation

fileprivate enum AsyncTaskState {
    case created
    case executing
    case finished
    
    var keyPath: String? {
        switch self {
        case .created: return nil
        case .executing: return "isExecuting"
        case .finished: return "isFinished"
        }
    }
}

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

    open override var isConcurrent: Bool { return true }
    open override var isAsynchronous: Bool { return true }
    open override var isExecuting: Bool { return _state == .executing }
    open override var isFinished: Bool { return _state == .finished }

    open override func start() {
        _state = .executing
        purgeDependencies()
        main()
    }

    open override func finish() {
        super.finish()
        _state = .finished
    }
}
