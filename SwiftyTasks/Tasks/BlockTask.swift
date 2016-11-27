//
//  BlockTask.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 9/12/16.
//  Copyright © 2016 address.wtf. All rights reserved.
//

import Foundation

/// `Task` subclass to wrap any code block into a `Task`
public final class BlockTask<ResultType>: Task<ResultType> {
    
    private let _block: () throws -> ResultType

    /// Initializes `BlockTask` with a throwing block
    ///
    /// - Parameter block: code block
    /// - Returns: Newly created `BlockTask` instance
    public init(_ block: @escaping () throws -> ResultType) {
        _block = block
    }
    
    /// Initializes `BlockTask` with a block returning optional result
    ///
    /// - Parameter block: code block
    /// - Returns: Newly created `BlockTask` instance
    public init(_ block: @escaping () -> ResultType?) {
        _block = {
            guard let result = block() else {
                throw TaskError.badResult
            }

            return result
        }
    }
    
    /// Performs actual execution. Do not call this method yourself.
    public override func main() {
        finish(_block)
    }
}
