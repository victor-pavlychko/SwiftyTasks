//
//  Task.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 9/12/16.
//  Copyright © 2016 address.wtf. All rights reserved.
//

import Foundation

/// Defines possible errors originating from SwiftyTasks library itself
///
/// - genericError: Generic error. You should never get this...
/// - badResult:    Operation returned `nil` for both result and error
/// - noResult:     Operation failed to provide result or error (probably it has not finished yey)
public enum TaskError: Error {
    case genericError
    case badResult
    case noResult
}

/// Internal data structure to hold task execution outcome
///
/// - none:    No result, similat ro Optional.none
/// - success: Task finished successfully with a result
/// - error:   Task failed with an error
fileprivate enum TaskResult<ResultType> {
    case none
    case success(ResultType)
    case error(Error)

    /// Initializes `TaskResult` with optional result and error
    ///
    /// - parameter result: optional result
    /// - parameter error:  optional error
    ///
    /// - returns: task result wrapping provided data
    init(result: ResultType?, error: Error? = nil) {
        if let error = error {
            self = .error(error)
            return
        }
        if let result = result {
            self = .success(result)
            return
        }
        self = .error(TaskError.badResult)
    }

    /// Initializes `TaskResult` using provided result block
    ///
    /// - parameter result: result block
    ///
    /// - returns: task result wrapping provided data
    init(_ result: () throws -> ResultType) {
        do {
            self = .success(try result())
        } catch {
            self = .error(error)
        }
    }
}

/// Base class for writing custom Tasks. Provides result handling and
/// removes dependencies on start to lower memory use.
open class Task<ResultType>: Operation, TaskProtocol {

    private var _result: TaskResult<ResultType> = .none

    /// Retrieves tast execution result or error
    ///
    /// - throws: captured error if any
    ///
    /// - returns: execution result
    public func getResult() throws -> ResultType {
        switch _result {
        case .none: throw TaskError.noResult
        case .success(let result): return result
        case .error(let error): throw error
        }
    }

    /// Marks task as finished with the result
    ///
    /// - parameter result: result value
    public func finish(result: ResultType) {
        _result = .success(result)
        finish()
    }

    /// Marks task as finished with the error
    ///
    /// - parameter result: error value
    public func finish(error: Error) {
        _result = .error(error)
        finish()
    }

    /// Marks task as finished with result or error
    ///
    /// - parameter result: optional result value
    /// - parameter error:  optional error value
    public func finish(result: ResultType?, error: Error?) {
        _result = .init(result: result, error: error)
        finish()
    }
    
    /// Marks task as finished with optional result.
    /// Error will be set to TaskError.badResult if `nil` is provided
    ///
    /// - parameter result: optional result value
    public func finish(result: ResultType?) {
        _result = .init(result: result)
        finish()
    }
    
    /// Marks task as finished with result taken from the block
    ///
    /// - parameter result: result block
    public func finish(_ result: () throws -> ResultType) {
        _result = .init(result)
        finish()
    }
    
    /// Marks task as finished with result taken from the block
    ///
    /// - parameter result: result block
    public func finish(_ result: @autoclosure () throws -> ResultType) {
        _result = .init(result)
        finish()
    }

    /// Detaches all dependencies and starts execution
    open override func start() {
        purgeDependencies()
        super.start()
    }
    
    /// Called by other finish(...) methods after storing task outcome.
    /// Use this as an extension point for custom finalizers.
    open func finish() {
    }
}
