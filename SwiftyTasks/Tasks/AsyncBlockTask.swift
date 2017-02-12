//
//  AsyncBlockTask.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 9/12/16.
//  Copyright © 2016 address.wtf. All rights reserved.
//

import Foundation

/// `AsyncTask` subclass to wrap any asynchronous code block into an `AsyncTask`
public final class AsyncBlockTask<ResultType>: AsyncTask<ResultType> {

    private var _block: ((AsyncBlockTask<ResultType>) throws -> Void)!

    public init(_ block: @escaping (AsyncBlockTask<ResultType>) throws -> Void) {
        _block = block
    }

    /// Initializes `AsyncBlockTask` with a code block tacking completion handler with result
    ///
    /// - Parameters:
    ///   - block:           code block
    ///   - completionBlock: completion handler passed to the code block
    ///   - result:          task result returned from the code block
    /// - Returns: Newly created `AsyncBlockTask` instance
    public init(_ block: @escaping (_ completionBlock: @escaping (_ result: ResultType) -> Void) throws -> Void) {
        _block = { try block($0.finish) }
    }
    
    /// Initializes `AsyncBlockTask` with a code block tacking completion handler with optional result and error
    ///
    /// - Parameters:
    ///   - block:           code block
    ///   - completionBlock: completion handler passed to the code block
    ///   - result:          task result returned from the code block
    ///   - error:           task error returned from the code block
    /// - Returns: Newly created `AsyncBlockTask` instance
    public init(_ block: @escaping (_ completionBlock: @escaping (_ result: ResultType?, _ error: Error?) -> Void) throws -> Void) {
        _block = { try block($0.finish) }
    }
    
    /// Initializes `AsyncBlockTask` with a code block tacking completion handler with optional result
    ///
    /// - Parameters:
    ///   - block:           code block
    ///   - completionBlock: completion handler passed to the code block
    ///   - result:          optional task result returned from the code block
    /// - Returns: Newly created `AsyncBlockTask` instance
    public init(_ block: @escaping (_ completionBlock: @escaping (_ result: ResultType?) -> Void) throws -> Void) {
        _block = { try block($0.finish) }
    }
    
    /// Initializes `AsyncBlockTask` with a code block tacking completion handler with a result block
    ///
    /// - Parameters:
    ///   - block:           code block
    ///   - completionBlock: completion handler passed to the code block
    ///   - resultBlock:     task result returned from the code block
    /// - Returns: Newly created `AsyncBlockTask` instance
    public init(_ block: @escaping (_ completionBlock: @escaping (_ resultBlock: () throws -> ResultType) -> Void) throws -> Void) {
        _block = { try block($0.finish) }
    }
    
    /// Starts execution. Do not call this method yourself.
    public override func main() {
        do {
            try _block(self)
            _block = nil
        } catch {
            finish(error: error)
        }
    }
}
