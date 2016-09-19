//
//  Task.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 9/12/16.
//  Copyright © 2016 address.wtf. All rights reserved.
//

import Foundation

/// <#Description#>
///
/// - genericError: <#genericError description#>
/// - badResult:    <#badResult description#>
/// - noResult:     <#noResult description#>
public enum OperationError: Error {
    case genericError
    case badResult
    case noResult
}

/// <#Description#>
///
/// - none:    <#none description#>
/// - success: <#success description#>
/// - error:   <#error description#>
fileprivate enum TaskResult<ResultType> {
    case none
    case success(ResultType)
    case error(Error)

    /// <#Description#>
    ///
    /// - parameter result: <#result description#>
    /// - parameter error:  <#error description#>
    ///
    /// - returns: <#return value description#>
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

    /// <#Description#>
    ///
    /// - parameter result: <#result description#>
    ///
    /// - returns: <#return value description#>
    init(_ result: () throws -> ResultType) {
        do {
            self = .success(try result())
        } catch {
            self = .error(error)
        }
    }
}

/// <#Description#>
open class Task<ResultType>: Operation, TaskProtocol {

    private var _result: TaskResult<ResultType> = .none

    /// <#Description#>
    ///
    /// - throws: <#throws value description#>
    ///
    /// - returns: <#return value description#>
    public func getResult() throws -> ResultType {
        switch _result {
        case .none: throw OperationError.noResult
        case .success(let result): return result
        case .error(let error): throw error
        }
    }

    /// <#Description#>
    ///
    /// - parameter result: <#result description#>
    public func finish(result: ResultType) {
        _result = .success(result)
        finish()
    }

    /// <#Description#>
    ///
    /// - parameter error: <#error description#>
    public func finish(error: Error) {
        _result = .error(error)
        finish()
    }

    /// <#Description#>
    ///
    /// - parameter result: <#result description#>
    /// - parameter error:  <#error description#>
    public func finish(result: ResultType?, error: Error?) {
        _result = .init(result: result, error: error)
        finish()
    }
    
    /// <#Description#>
    ///
    /// - parameter result: <#result description#>
    public func finish(result: ResultType?) {
        _result = .init(result: result)
        finish()
    }
    
    /// <#Description#>
    ///
    /// - parameter result: <#result description#>
    public func finish(_ result: () throws -> ResultType) {
        _result = .init(result)
        finish()
    }
    
    /// <#Description#>
    ///
    /// - parameter result: <#result description#>
    public func finish(_ result: @autoclosure () throws -> ResultType) {
        _result = .init(result)
        finish()
    }

    /// <#Description#>
    open override func start() {
        purgeDependencies()
        super.start()
    }
    
    /// <#Description#>
    open func finish() {
    }
}
