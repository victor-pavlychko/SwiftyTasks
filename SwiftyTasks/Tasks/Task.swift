//
//  Task.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 9/12/16.
//  Copyright © 2016 address.wtf. All rights reserved.
//

import Foundation

public enum OperationError: Error {
    case genericError
    case badResult
    case noResult
}

fileprivate enum TaskResult<ResultType> {
    case none
    case success(ResultType)
    case error(Error)

    init(result: ResultType?, error: Error? = nil) {
        if let error = error {
            self = .error(error)
            return
        }
        if let result = result {
            self = .success(result)
            return
        }
        self = .error(OperationError.badResult)
    }

    init(_ result: () throws -> ResultType) {
        do {
            self = .success(try result())
        } catch {
            self = .error(error)
        }
    }
}

open class Task<ResultType>: Operation, TaskProtocol {

    private var _result: TaskResult<ResultType> = .none

    public func getResult() throws -> ResultType {
        switch _result {
        case .none: throw OperationError.noResult
        case .success(let result): return result
        case .error(let error): throw error
        }
    }

    public func finish(result: ResultType) {
        _result = .success(result)
        finish()
    }

    public func finish(error: Error) {
        _result = .error(error)
        finish()
    }

    public func finish(result: ResultType?, error: Error?) {
        _result = .init(result: result, error: error)
        finish()
    }
    
    public func finish(result: ResultType?) {
        _result = .init(result: result)
        finish()
    }
    
    public func finish(_ result: () throws -> ResultType) {
        _result = .init(result)
        finish()
    }
    
    public func finish(_ result: @autoclosure () throws -> ResultType) {
        _result = .init(result)
        finish()
    }

    open override func start() {
        purgeDependencies()
        super.start()
    }
    
    open func finish() {
    }
}
