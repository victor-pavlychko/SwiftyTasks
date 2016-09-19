//
//  BlockTask.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 9/12/16.
//  Copyright © 2016 address.wtf. All rights reserved.
//

import Foundation

/// <#Description#>
public final class BlockTask<ResultType>: Task<ResultType> {
    
    private let _block: () throws -> ResultType

    /// <#Description#>
    ///
    /// - parameter block: <#block description#>
    ///
    /// - returns: <#return value description#>
    public init(_ block: @escaping () throws -> ResultType) {
        _block = block
    }
    
    /// <#Description#>
    ///
    /// - parameter block: <#block description#>
    ///
    /// - returns: <#return value description#>
    public init(_ block: @escaping () -> ResultType?) {
        _block = {
            guard let result = block() else {
                throw OperationError.badResult
            }

            return result
        }
    }
    
    /// <#Description#>
    public override func main() {
        finish(_block)
    }
}
