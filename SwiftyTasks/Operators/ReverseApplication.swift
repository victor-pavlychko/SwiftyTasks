//
//  ReverseApplication.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 9/19/16.
//  Copyright © 2016 address.wtf. All rights reserved.
//

import Foundation

public func ~> <R, T0> (args: T0, fn: @escaping (T0) -> R) -> () -> R {
    return fn <~ args
}

public func ~> <R, T0> (args: T0, fn: @escaping (T0) throws -> R) -> () throws -> R {
    return fn <~ args
}

public func ~> <R, P0: TaskProtocol> (args: P0, fn: @escaping (P0.ResultType) throws -> R) -> AdapterTask<R> {
    return fn <~ args
}

public func ~> <R: TaskProtocol, T0> (args: T0, fn: @escaping (T0) -> R) -> R {
    return fn <~ args
}

public func ~> <R: TaskProtocol, T0> (args: T0, fn: @escaping (T0) throws -> R) -> Task<R.ResultType> {
    return fn <~ args
}

public func ~> <R: TaskProtocol, P0: TaskProtocol> (args: P0, fn: @escaping (P0.ResultType) throws -> R) -> Task<R.ResultType> {
    return fn <~ args
}


public func ~> <R, T0, T1> (args: (T0, T1), fn: @escaping (T0, T1) -> R) -> () -> R {
    return fn <~ args.0 <~ args.1
}

public func ~> <R, T0, T1> (args: (T0, T1), fn: @escaping (T0, T1) throws -> R) -> () throws -> R {
    return fn <~ args.0 <~ args.1
}

public func ~> <R, P0: TaskProtocol, T1> (args: (P0, T1), fn: @escaping (P0.ResultType, T1) throws -> R) -> AdapterTask<R> {
    return fn <~ args.0 <~ args.1
}

public func ~> <R, T0, P1: TaskProtocol> (args: (T0, P1), fn: @escaping (T0, P1.ResultType) throws -> R) -> AdapterTask<R> {
    return fn <~ args.0 <~ args.1
}

public func ~> <R, P0: TaskProtocol, P1: TaskProtocol> (args: (P0, P1), fn: @escaping (P0.ResultType, P1.ResultType) throws -> R) -> AdapterTask<R> {
    return fn <~ args.0 <~ args.1
}

public func ~> <R: TaskProtocol, T0, T1> (args: (T0, T1), fn: @escaping (T0, T1) -> R) -> R {
    return fn <~ args.0 <~ args.1
}

public func ~> <R: TaskProtocol, T0, T1> (args: (T0, T1), fn: @escaping (T0, T1) throws -> R) -> Task<R.ResultType> {
    return fn <~ args.0 <~ args.1
}

public func ~> <R: TaskProtocol, P0: TaskProtocol, T1> (args: (P0, T1), fn: @escaping (P0.ResultType, T1) throws -> R) -> Task<R.ResultType> {
    return fn <~ args.0 <~ args.1
}

public func ~> <R: TaskProtocol, P0: TaskProtocol, P1: TaskProtocol> (args: (P0, P1), fn: @escaping (P0.ResultType, P1.ResultType) throws -> R) -> Task<R.ResultType> {
    return fn <~ args.0 <~ args.1
}


public func ~> <R, T0, T1, T2> (args: (T0, T1, T2), fn: @escaping (T0, T1, T2) -> R) -> () -> R {
    return fn <~ args.0 <~ args.1 <~ args.2
}

public func ~> <R, T0, T1, T2> (args: (T0, T1, T2), fn: @escaping (T0, T1, T2) throws -> R) -> () throws -> R {
    return fn <~ args.0 <~ args.1 <~ args.2
}

public func ~> <R, P0: TaskProtocol, T1, T2> (args: (P0, T1, T2), fn: @escaping (P0.ResultType, T1, T2) throws -> R) -> AdapterTask<R> {
    return fn <~ args.0 <~ args.1 <~ args.2
}

public func ~> <R, T0, P1: TaskProtocol, T2> (args: (T0, P1, T2), fn: @escaping (T0, P1.ResultType, T2) throws -> R) -> AdapterTask<R> {
    return fn <~ args.0 <~ args.1 <~ args.2
}

public func ~> <R, P0: TaskProtocol, P1: TaskProtocol, T2> (args: (P0, P1, T2), fn: @escaping (P0.ResultType, P1.ResultType, T2) throws -> R) -> AdapterTask<R> {
    return fn <~ args.0 <~ args.1 <~ args.2
}

public func ~> <R, T0, T1, P2: TaskProtocol> (args: (T0, T1, P2), fn: @escaping (T0, T1, P2.ResultType) throws -> R) -> AdapterTask<R> {
    return fn <~ args.0 <~ args.1 <~ args.2
}

public func ~> <R, P0: TaskProtocol, T1, P2: TaskProtocol> (args: (P0, T1, P2), fn: @escaping (P0.ResultType, T1, P2.ResultType) throws -> R) -> AdapterTask<R> {
    return fn <~ args.0 <~ args.1 <~ args.2
}

public func ~> <R, T0, P1: TaskProtocol, P2: TaskProtocol> (args: (T0, P1, P2), fn: @escaping (T0, P1.ResultType, P2.ResultType) throws -> R) -> AdapterTask<R> {
    return fn <~ args.0 <~ args.1 <~ args.2
}

public func ~> <R, P0: TaskProtocol, P1: TaskProtocol, P2: TaskProtocol> (args: (P0, P1, P2), fn: @escaping (P0.ResultType, P1.ResultType, P2.ResultType) throws -> R) -> AdapterTask<R> {
    return fn <~ args.0 <~ args.1 <~ args.2
}

public func ~> <R: TaskProtocol, T0, T1, T2> (args: (T0, T1, T2), fn: @escaping (T0, T1, T2) -> R) -> R {
    return fn <~ args.0 <~ args.1 <~ args.2
}

public func ~> <R: TaskProtocol, T0, T1, T2> (args: (T0, T1, T2), fn: @escaping (T0, T1, T2) throws -> R) -> Task<R.ResultType> {
    return fn <~ args.0 <~ args.1 <~ args.2
}

public func ~> <R: TaskProtocol, P0: TaskProtocol, T1, T2> (args: (P0, T1, T2), fn: @escaping (P0.ResultType, T1, T2) throws -> R) -> Task<R.ResultType> {
    return fn <~ args.0 <~ args.1 <~ args.2
}

public func ~> <R: TaskProtocol, P0: TaskProtocol, P1: TaskProtocol, T2> (args: (P0, P1, T2), fn: @escaping (P0.ResultType, P1.ResultType, T2) throws -> R) -> Task<R.ResultType> {
    return fn <~ args.0 <~ args.1 <~ args.2
}

public func ~> <R: TaskProtocol, T0, T1, P2: TaskProtocol> (args: (T0, T1, P2), fn: @escaping (T0, T1, P2.ResultType) -> R) -> Task<R.ResultType> {
    return fn <~ args.0 <~ args.1 <~ args.2
}

public func ~> <R: TaskProtocol, T0, T1, P2: TaskProtocol> (args: (T0, T1, P2), fn: @escaping (T0, T1, P2.ResultType) throws -> R) -> Task<R.ResultType> {
    return fn <~ args.0 <~ args.1 <~ args.2
}

public func ~> <R: TaskProtocol, P0: TaskProtocol, T1, P2: TaskProtocol> (args: (P0, T1, P2), fn: @escaping (P0.ResultType, T1, P2.ResultType) throws -> R) -> Task<R.ResultType> {
    return fn <~ args.0 <~ args.1 <~ args.2
}

public func ~> <R: TaskProtocol, P0: TaskProtocol, P1: TaskProtocol, P2: TaskProtocol> (args: (P0, P1, P2), fn: @escaping (P0.ResultType, P1.ResultType, P2.ResultType) throws -> R) -> Task<R.ResultType> {
    return fn <~ args.0 <~ args.1 <~ args.2
}
