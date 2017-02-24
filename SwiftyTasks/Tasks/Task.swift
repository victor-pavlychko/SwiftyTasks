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
    
    private let _lock = NSLock()
    private var _isPaused = false
    private var _isCancelled = false

    /// <#Description#>
    public let progress = Progress.discreteProgress(totalUnitCount: 0)

    /// <#Description#>
    public override init() {
        super.init()
        progress.isCancellable = true
        progress.cancellationHandler = { [weak self] in self?.cancel() }
        progress.pausingHandler = { [weak self] in self?.pause() }
        progress.resumingHandler = { [weak self] in self?.resume() }
    }
    
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
        super.start()
    }
    
    open func handleCancelled() { }

    public final override func cancel() {
        super.cancel()
        _lock.syncAndSet(variable: &_isCancelled, value: true, execute: handleCancelled)
    }
    
    /// <#Description#>
    public final var isPaused: Bool {
        return _isPaused
    }
    
    open func handlePaused() { }

    /// <#Description#>
    public final func pause() {
        _lock.syncAndSet(variable: &_isPaused, value: true, execute: handlePaused)
    }
    
    open func handleResumed() { }
    
    /// <#Description#>
    public final func resume() {
        _lock.syncAndSet(variable: &_isPaused, value: false, execute: handleResumed)
    }
    
    /// Called by other finish(...) methods after storing task outcome.
    /// Use this as an extension point for custom finalizers.
    open func finish() {
    }

    /// <#Description#>
    internal func _finish() {
        finish()
        progress.complete()
    }
}
