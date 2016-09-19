//
//  BlockTask.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 9/12/16.
//  Copyright © 2016 address.wtf. All rights reserved.
//

import Foundation

public final class BlockTask<ResultType>: Task<ResultType> {
    
    private let _block: () throws -> ResultType

    public init(_ block: @escaping () throws -> ResultType) {
        _block = block
    }
    
    public init(_ block: @escaping () -> ResultType?) {
        _block = {
            guard let result = block() else {
                throw OperationError.badResult
            }

            return result
        }
    }
    
    public override func main() {
        finish(_block)
    }
}
