//
//  ReverseApplication.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 9/19/16.
//  Copyright © 2016 address.wtf. All rights reserved.
//

import Foundation

public func ~> <R, T0> (lhs: T0, rhs: @escaping (T0) -> R) -> () -> R {
    return rhs <~ lhs
}

public func ~> <R, T0> (lhs: T0, rhs: @escaping (T0) throws -> R) -> () throws -> R {
    return rhs <~ lhs
}

public func ~> <R, P0: TaskProtocol> (lhs: P0, rhs: @escaping (P0.ResultType) throws -> R) -> AdapterTask<R> {
    return rhs <~ lhs
}

public func ~> <R: TaskProtocol, T0> (lhs: T0, rhs: @escaping (T0) -> R) -> R {
    return rhs <~ lhs
}

public func ~> <R: TaskProtocol, T0> (lhs: T0, rhs: @escaping (T0) throws -> R) -> Task<R.ResultType> {
    return rhs <~ lhs
}

public func ~> <R: TaskProtocol, P0: TaskProtocol> (lhs: P0, rhs: @escaping (P0.ResultType) throws -> R) -> Task<R.ResultType> {
    return rhs <~ lhs
}


public func ~> <R, T0, T1> (lhs: (T0, T1), rhs: @escaping (T0, T1) -> R) -> () -> R {
    return rhs <~ lhs.0 <~ lhs.1
}

public func ~> <R, T0, T1> (lhs: (T0, T1), rhs: @escaping (T0, T1) throws -> R) -> () throws -> R {
    return rhs <~ lhs.0 <~ lhs.1
}

public func ~> <R, P0: TaskProtocol, T1> (lhs: (P0, T1), rhs: @escaping (P0.ResultType, T1) throws -> R) -> AdapterTask<R> {
    return rhs <~ lhs.0 <~ lhs.1
}

public func ~> <R, T0, P1: TaskProtocol> (lhs: (T0, P1), rhs: @escaping (T0, P1.ResultType) throws -> R) -> AdapterTask<R> {
    return rhs <~ lhs.0 <~ lhs.1
}

public func ~> <R, P0: TaskProtocol, P1: TaskProtocol> (lhs: (P0, P1), rhs: @escaping (P0.ResultType, P1.ResultType) throws -> R) -> AdapterTask<R> {
    return rhs <~ lhs.0 <~ lhs.1
}

public func ~> <R: TaskProtocol, T0, T1> (lhs: (T0, T1), rhs: @escaping (T0, T1) -> R) -> R {
    return rhs <~ lhs.0 <~ lhs.1
}

public func ~> <R: TaskProtocol, T0, T1> (lhs: (T0, T1), rhs: @escaping (T0, T1) throws -> R) -> Task<R.ResultType> {
    return rhs <~ lhs.0 <~ lhs.1
}

public func ~> <R: TaskProtocol, P0: TaskProtocol, T1> (lhs: (P0, T1), rhs: @escaping (P0.ResultType, T1) throws -> R) -> Task<R.ResultType> {
    return rhs <~ lhs.0 <~ lhs.1
}

public func ~> <R: TaskProtocol, P0: TaskProtocol, P1: TaskProtocol> (lhs: (P0, P1), rhs: @escaping (P0.ResultType, P1.ResultType) throws -> R) -> Task<R.ResultType> {
    return rhs <~ lhs.0 <~ lhs.1
}


public func ~> <R, T0, T1, T2> (lhs: (T0, T1, T2), rhs: @escaping (T0, T1, T2) -> R) -> () -> R {
    return rhs <~ lhs.0 <~ lhs.1 <~ lhs.2
}

public func ~> <R, T0, T1, T2> (lhs: (T0, T1, T2), rhs: @escaping (T0, T1, T2) throws -> R) -> () throws -> R {
    return rhs <~ lhs.0 <~ lhs.1 <~ lhs.2
}

public func ~> <R, P0: TaskProtocol, T1, T2> (lhs: (P0, T1, T2), rhs: @escaping (P0.ResultType, T1, T2) throws -> R) -> AdapterTask<R> {
    return rhs <~ lhs.0 <~ lhs.1 <~ lhs.2
}

public func ~> <R, T0, P1: TaskProtocol, T2> (lhs: (T0, P1, T2), rhs: @escaping (T0, P1.ResultType, T2) throws -> R) -> AdapterTask<R> {
    return rhs <~ lhs.0 <~ lhs.1 <~ lhs.2
}

public func ~> <R, P0: TaskProtocol, P1: TaskProtocol, T2> (lhs: (P0, P1, T2), rhs: @escaping (P0.ResultType, P1.ResultType, T2) throws -> R) -> AdapterTask<R> {
    return rhs <~ lhs.0 <~ lhs.1 <~ lhs.2
}

public func ~> <R, T0, T1, P2: TaskProtocol> (lhs: (T0, T1, P2), rhs: @escaping (T0, T1, P2.ResultType) throws -> R) -> AdapterTask<R> {
    return rhs <~ lhs.0 <~ lhs.1 <~ lhs.2
}

public func ~> <R, P0: TaskProtocol, T1, P2: TaskProtocol> (lhs: (P0, T1, P2), rhs: @escaping (P0.ResultType, T1, P2.ResultType) throws -> R) -> AdapterTask<R> {
    return rhs <~ lhs.0 <~ lhs.1 <~ lhs.2
}

public func ~> <R, T0, P1: TaskProtocol, P2: TaskProtocol> (lhs: (T0, P1, P2), rhs: @escaping (T0, P1.ResultType, P2.ResultType) throws -> R) -> AdapterTask<R> {
    return rhs <~ lhs.0 <~ lhs.1 <~ lhs.2
}

public func ~> <R, P0: TaskProtocol, P1: TaskProtocol, P2: TaskProtocol> (lhs: (P0, P1, P2), rhs: @escaping (P0.ResultType, P1.ResultType, P2.ResultType) throws -> R) -> AdapterTask<R> {
    return rhs <~ lhs.0 <~ lhs.1 <~ lhs.2
}

public func ~> <R: TaskProtocol, T0, T1, T2> (lhs: (T0, T1, T2), rhs: @escaping (T0, T1, T2) -> R) -> R {
    return rhs <~ lhs.0 <~ lhs.1 <~ lhs.2
}

public func ~> <R: TaskProtocol, T0, T1, T2> (lhs: (T0, T1, T2), rhs: @escaping (T0, T1, T2) throws -> R) -> Task<R.ResultType> {
    return rhs <~ lhs.0 <~ lhs.1 <~ lhs.2
}

public func ~> <R: TaskProtocol, P0: TaskProtocol, T1, T2> (lhs: (P0, T1, T2), rhs: @escaping (P0.ResultType, T1, T2) throws -> R) -> Task<R.ResultType> {
    return rhs <~ lhs.0 <~ lhs.1 <~ lhs.2
}

public func ~> <R: TaskProtocol, P0: TaskProtocol, P1: TaskProtocol, T2> (lhs: (P0, P1, T2), rhs: @escaping (P0.ResultType, P1.ResultType, T2) throws -> R) -> Task<R.ResultType> {
    return rhs <~ lhs.0 <~ lhs.1 <~ lhs.2
}

public func ~> <R: TaskProtocol, T0, T1, P2: TaskProtocol> (lhs: (T0, T1, P2), rhs: @escaping (T0, T1, P2.ResultType) -> R) -> Task<R.ResultType> {
    return rhs <~ lhs.0 <~ lhs.1 <~ lhs.2
}

public func ~> <R: TaskProtocol, T0, T1, P2: TaskProtocol> (lhs: (T0, T1, P2), rhs: @escaping (T0, T1, P2.ResultType) throws -> R) -> Task<R.ResultType> {
    return rhs <~ lhs.0 <~ lhs.1 <~ lhs.2
}

public func ~> <R: TaskProtocol, P0: TaskProtocol, T1, P2: TaskProtocol> (lhs: (P0, T1, P2), rhs: @escaping (P0.ResultType, T1, P2.ResultType) throws -> R) -> Task<R.ResultType> {
    return rhs <~ lhs.0 <~ lhs.1 <~ lhs.2
}

public func ~> <R: TaskProtocol, P0: TaskProtocol, P1: TaskProtocol, P2: TaskProtocol> (lhs: (P0, P1, P2), rhs: @escaping (P0.ResultType, P1.ResultType, P2.ResultType) throws -> R) -> Task<R.ResultType> {
    return rhs <~ lhs.0 <~ lhs.1 <~ lhs.2
}
