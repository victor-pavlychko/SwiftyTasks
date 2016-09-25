//
//  TaskProtocol.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 9/15/16.
//  Copyright © 2016 address.wtf. All rights reserved.
//

import Foundation

/// <#Description#>
public protocol AnyTask {

    /// <#Description#>
    var backingOperations: [Operation] { get }
}

/// <#Description#>
public protocol TaskProtocol: AnyTask {

    associatedtype ResultType

    /// <#Description#>
    ///
    /// - throws: <#throws value description#>
    ///
    /// - returns: <#return value description#>
    func getResult() throws -> ResultType
}

extension Operation: AnyTask {
    
    /// <#Description#>
    public var backingOperations: [Operation] {
        return [self]
    }
}

public extension AnyTask {

    /// <#Description#>
    ///
    /// - parameter completionBlock: <#completionBlock description#>
    func start(_ completionBlock: @escaping () -> Void) {
        guard !backingOperations.isEmpty else {
            completionBlock()
            return
        }

        var counter: Int32 = Int32(backingOperations.count)
        let countdownBlock = {
            if (OSAtomicDecrement32Barrier(&counter) == 0) {
                completionBlock()
            }
        }
        for operation in backingOperations {
            if operation.isAsynchronous {
                operation.completionBlock = countdownBlock
                operation.start()
            }
        }
        for operation in backingOperations {
            if !operation.isAsynchronous {
                operation.start()
                countdownBlock()
            }
        }
    }
}

public extension TaskProtocol {

    /// <#Description#>
    ///
    /// - parameter completionBlock: <#completionBlock description#>
    /// - parameter resultBlock:     <#completionBlock description#>
    func start(_ completionBlock: @escaping (_ resultBlock: () throws -> ResultType) -> Void) {
        start { completionBlock(self.getResult) }
    }
}
