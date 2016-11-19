//
//  TaskResult.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 11/19/16.
//  Copyright © 2016 address.wtf. All rights reserved.
//

import Foundation

/// Internal data structure to hold task execution outcome
///
/// - none:    No result, similat ro Optional.none
/// - success: Task finished successfully with a result
/// - error:   Task failed with an error
enum TaskResult<ResultType> {
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
    
    /// Retrieves task execution result or error
    ///
    /// - throws: captured error if any
    ///
    /// - returns: execution result
    public func get() throws -> ResultType {
        switch self {
        case .none: throw TaskError.noResult
        case .success(let result): return result
        case .error(let error): throw error
        }
    }
}
