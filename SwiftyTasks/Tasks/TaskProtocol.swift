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
    var backingOperation: Operation { get }
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

public extension AnyTask {

    /// <#Description#>
    ///
    /// - parameter completionBlock: <#completionBlock description#>
    func start(_ completionBlock: @escaping () -> Void) {
        if backingOperation.isAsynchronous {
            backingOperation.completionBlock = completionBlock
            backingOperation.start()
        } else {
            backingOperation.start()
            completionBlock()
        }
    }
}

public extension AnyTask where Self: Operation {

    /// <#Description#>
    public var backingOperation: Operation {
        return self
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
