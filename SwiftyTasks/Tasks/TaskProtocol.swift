//
//  TaskProtocol.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 9/15/16.
//  Copyright © 2016 address.wtf. All rights reserved.
//

import Foundation

public protocol AnyTask {
    var backingOperation: Operation { get }
}

public protocol TaskProtocol: AnyTask {
    associatedtype ResultType
    func getResult() throws -> ResultType
}

public extension AnyTask {
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
    public var backingOperation: Operation {
        return self
    }
}

public extension TaskProtocol {
    func start(_ completionBlock: @escaping (() throws -> ResultType) -> Void) {
        start { completionBlock(self.getResult) }
    }
}
