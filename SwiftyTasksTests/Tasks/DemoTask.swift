//
//  DemoTask.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 9/19/16.
//  Copyright © 2016 address.wtf. All rights reserved.
//

import Foundation
import SwiftyTasks

enum DemoTaskResult<ResultType> {
    case success(ResultType)
    case error(Error)
    case successOrError(ResultType?, Error?)
    case optionalSuccess(ResultType?)
    case resultBlock(() throws -> ResultType)
    
    fileprivate func finish(task: Task<ResultType>) {
        switch (self) {
        case let .success(result):                  task.finish(result: result)
        case let .error(error):                     task.finish(error: error)
        case let .successOrError(result, error):    task.finish(result: result, error: error)
        case let .optionalSuccess(result):          task.finish(result: result)
        case let .resultBlock(resultBlock):         task.finish(resultBlock)
        }
    }
}

class DemoTask<ResultType>: Task<ResultType> {
    
    private var _result: DemoTaskResult<ResultType>
    
    init(_ result: DemoTaskResult<ResultType>) {
        _result = result
    }
    
    override func main() {
        _result.finish(task: self)
    }
}

class DemoAsyncTask<ResultType>: AsyncTask<ResultType> {
    
    private var _result: DemoTaskResult<ResultType>
    
    init(_ result: DemoTaskResult<ResultType>) {
        _result = result
    }

    override func main() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) { 
            self._result.finish(task: self)
        }
    }
}
