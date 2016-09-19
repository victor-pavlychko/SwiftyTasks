//
//  Enqueue.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 9/18/16.
//  Copyright © 2016 address.wtf. All rights reserved.
//

import Foundation

public func <= <T: Operation> (lhs: OperationQueue, rhs: T) -> T {
    lhs.addOperation(rhs)
    return rhs
}

public func <= <T: TaskProtocol> (lhs: OperationQueue, rhs: T) -> T {
    lhs.addOperation(rhs.backingOperation)
    return rhs
}

public func += <T: Operation> (lhs: OperationQueue, rhs: T) -> T {
    lhs.addOperation(rhs)
    return rhs
}

public func += <T: TaskProtocol> (lhs: OperationQueue, rhs: T) -> T {
    lhs.addOperation(rhs.backingOperation)
    return rhs
}
