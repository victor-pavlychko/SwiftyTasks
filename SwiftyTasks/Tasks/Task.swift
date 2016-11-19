//
//  Task.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 9/12/16.
//  Copyright © 2016 address.wtf. All rights reserved.
//

import Foundation

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
        return try _result.get()
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
