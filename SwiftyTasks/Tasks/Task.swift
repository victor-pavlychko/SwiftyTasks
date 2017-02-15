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
open class Task<ResultType>: Operation, ProgressReporting, TaskProtocol {

    private let _result = Pending<ResultType>()

    /// <#Description#>
    public let progress = Progress.discreteProgress(totalUnitCount: -1)
    
    /// Retrieves tast execution result or error
    ///
    /// - Throws: captured error if any
    /// - Returns: execution result
    public final func getResult() throws -> ResultType {
        return try _result.get()
    }
    
    /// Retrieves tast execution result or error
    ///
    /// - Throws: captured error if any
    /// - Returns: execution result
    public final func wait() {
        _result.wait()
    }
    
    /// Marks task as finished with the result
    ///
    /// - Parameter result: result value
    public final func finish(result: ResultType) {
        _result.set(result: result)
        _finish()
    }

    /// Marks task as finished with the error
    ///
    /// - Parameter result: error value
    public final func finish(error: Error) {
        _result.set(error: error)
        _finish()
    }

    /// Marks task as finished with result or error
    ///
    /// - Parameters:
    ///   - result: optional result value
    ///   - error:  optional error value
    public final func finish(result: ResultType?, error: Error?) {
        _result.set(result: result, error: error)
        _finish()
    }
    
    /// Marks task as finished with optional result.
    /// Error will be set to TaskError.badResult if `nil` is provided
    ///
    /// - Parameter result: optional result value
    public final func finish(result: ResultType?) {
        _result.set(result: result)
        _finish()
    }
    
    /// Marks task as finished with result taken from the block
    ///
    /// - Parameter result: result block
    public final func finish(_ result: () throws -> ResultType) {
        _result.set(result)
        _finish()
    }
    
    /// Marks task as finished with result taken from the block
    ///
    /// - Parameter result: result block
    public final func finish(_ result: @autoclosure () throws -> ResultType) {
        _result.set(result)
        _finish()
    }

    /// Detaches all dependencies and starts execution
    open override func start() {
        purgeDependencies()
        progress.isCancellable = true
        progress.cancellationHandler = { [weak self] in self?.cancel() }
        progress.pausingHandler = { [weak self] in self?.pause() }
        progress.resumingHandler = { [weak self] in self?.resume() }
        super.start()
    }
    
    /// <#Description#>
    open func pause() {
    }
    
    /// <#Description#>
    open func resume() {
    }
    
    /// Called by other finish(...) methods after storing task outcome.
    /// Use this as an extension point for custom finalizers.
    open func finish() {
    }

    /// <#Description#>
    private func _finish() {
        finish()
        if progress.totalUnitCount > 0 {
            progress.completedUnitCount = progress.totalUnitCount
        } else {
            progress.completedUnitCount = 1
            progress.completedUnitCount = 1
        }
    }
}
