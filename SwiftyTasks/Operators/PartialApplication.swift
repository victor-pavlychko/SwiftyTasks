//
//  PartialApplication.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 9/18/16.
//  Copyright © 2016 address.wtf. All rights reserved.
//

import Foundation

public func <~ <R, T0> (lhs: @escaping (T0) -> R, rhs: T0) -> () -> R {
    return { lhs(rhs) }
}

public func <~ <R, T0, T1> (lhs: @escaping (T0, T1) -> R, rhs: T0) -> (T1) -> R {
    return { a1 in lhs(rhs, a1) }
}

public func <~ <R, T0, T1, T2> (lhs: @escaping (T0, T1, T2) -> R, rhs: T0) -> (T1, T2) -> R {
    return { a1, a2 in lhs(rhs, a1, a2) }
}


public func <~ <R, T0> (lhs: @escaping (T0) throws -> R, rhs: T0) -> () throws -> R {
    return { try lhs(rhs) }
}

public func <~ <R, T0, T1> (lhs: @escaping (T0, T1) throws -> R, rhs: T0) -> (T1) throws -> R {
    return { a1 in try lhs(rhs, a1) }
}

public func <~ <R, T0, T1, T2> (lhs: @escaping (T0, T1, T2) throws -> R, rhs: T0) -> (T1, T2) throws -> R {
    return { a1, a2 in try lhs(rhs, a1, a2) }
}


public func <~ <R, P0: TaskProtocol> (lhs: @escaping (P0.ResultType) throws -> R, rhs: P0) -> AdapterTask<R> {
    return AdapterTask([rhs]) { try lhs(rhs.getResult()) }
}

public func <~ <R, P0: TaskProtocol, T1> (lhs: @escaping (P0.ResultType, T1) throws -> R, rhs: P0) -> (T1) -> AdapterTask<R> {
    return { a1 in return AdapterTask([rhs]) { try lhs(rhs.getResult(), a1) } }
}

public func <~ <R, P0: TaskProtocol, T1, T2> (lhs: @escaping (P0.ResultType, T1, T2) throws -> R, rhs: P0) -> (T1, T2) -> AdapterTask<R> {
    return { a1, a2 in return AdapterTask([rhs]) { try lhs(rhs.getResult(), a1, a2) } }
}


public func <~ <R: TaskProtocol, T0> (lhs: @escaping (T0) -> R, rhs: T0) -> R {
    return lhs(rhs)
}

public func <~ <R: TaskProtocol, T0, T1> (lhs: @escaping (T0, T1) -> R, rhs: T0) -> (T1) -> R {
    return { a1 in lhs(rhs, a1) }
}

public func <~ <R: TaskProtocol, T0, T1, T2> (lhs: @escaping (T0, T1, T2) -> R, rhs: T0) -> (T1, T2) -> R {
    return { a1, a2 in lhs(rhs, a1, a2) }
}


public func <~ <R: TaskProtocol, T0> (lhs: @escaping (T0) throws -> R, rhs: T0) -> Task<R.ResultType> {
    return AsyncBlockTask { completionHandler in try lhs(rhs).start(completionHandler) }
}

public func <~ <R: TaskProtocol, T0, T1> (lhs: @escaping (T0, T1) throws -> R, rhs: T0) -> (T1) throws -> R {
    return { a1 in try lhs(rhs, a1) }
}

public func <~ <R: TaskProtocol, T0, T1, T2> (lhs: @escaping (T0, T1, T2) throws -> R, rhs: T0) -> (T1, T2) throws -> R {
    return { a1, a2 in try lhs(rhs, a1, a2) }
}


public func <~ <R: TaskProtocol, P0: TaskProtocol> (lhs: @escaping (P0.ResultType) throws -> R, rhs: P0) -> Task<R.ResultType> {
    return AsyncBlockTask { completionHandler in try lhs(rhs.getResult()).start(completionHandler) } ~~ rhs
}

public func <~ <R: TaskProtocol, P0: TaskProtocol, T1> (lhs: @escaping (P0.ResultType, T1) throws -> R, rhs: P0) -> (T1) -> Task<R.ResultType> {
    return { a1 in return AsyncBlockTask { completionHandler in try lhs(rhs.getResult(), a1).start(completionHandler) } ~~ rhs }
}

public func <~ <R: TaskProtocol, P0: TaskProtocol, T1, T2> (lhs: @escaping (P0.ResultType, T1, T2) throws -> R, rhs: P0) -> (T1, T2) -> Task<R.ResultType> {
    return { a1, a2 in return AsyncBlockTask { completionHandler in try lhs(rhs.getResult(), a1, a2).start(completionHandler) } ~~ rhs }
}


public func <~ <R, P0: TaskProtocol> (lhs: @escaping (P0.ResultType) throws -> AdapterTask<R>, rhs: P0) -> AdapterTask<R> {
    return AdapterTask([rhs]) { try lhs(rhs.getResult()).getResult() }
}

public func <~ <R, P0: TaskProtocol, T1> (lhs: @escaping (P0.ResultType, T1) throws -> AdapterTask<R>, rhs: P0) -> (T1) -> AdapterTask<R> {
    return { a1 in return AdapterTask([rhs]) { try lhs(rhs.getResult(), a1).getResult() } }
}

public func <~ <R, P0: TaskProtocol, T1, T2> (lhs: @escaping (P0.ResultType, T1, T2) throws -> AdapterTask<R>, rhs: P0) -> (T1, T2) -> AdapterTask<R> {
    return { a1, a2 in return AdapterTask([rhs]) { try lhs(rhs.getResult(), a1, a2).getResult() } }
}
