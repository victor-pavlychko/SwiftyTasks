//
//  PartialApplication.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 9/18/16.
//  Copyright © 2016 address.wtf. All rights reserved.
//

import Foundation

public func <~ <R, T0> (fn: @escaping (T0) -> R, args: T0) -> () -> R {
    return { fn(args) }
}

public func <~ <R, T0, T1> (fn: @escaping (T0, T1) -> R, args: T0) -> (T1) -> R {
    return { a1 in fn(args, a1) }
}

public func <~ <R, T0, T1, T2> (fn: @escaping (T0, T1, T2) -> R, args: T0) -> (T1, T2) -> R {
    return { a1, a2 in fn(args, a1, a2) }
}


public func <~ <R, T0> (fn: @escaping (T0) throws -> R, args: T0) -> () throws -> R {
    return { try fn(args) }
}

public func <~ <R, T0, T1> (fn: @escaping (T0, T1) throws -> R, args: T0) -> (T1) throws -> R {
    return { a1 in try fn(args, a1) }
}

public func <~ <R, T0, T1, T2> (fn: @escaping (T0, T1, T2) throws -> R, args: T0) -> (T1, T2) throws -> R {
    return { a1, a2 in try fn(args, a1, a2) }
}


public func <~ <R, P0: TaskProtocol> (fn: @escaping (P0.ResultType) throws -> R, args: P0) -> AdapterTask<R> {
    return AdapterTask([args]) { try fn(args.getResult()) }
}

public func <~ <R, P0: TaskProtocol, T1> (fn: @escaping (P0.ResultType, T1) throws -> R, args: P0) -> (T1) -> AdapterTask<R> {
    return { a1 in return AdapterTask([args]) { try fn(args.getResult(), a1) } }
}

public func <~ <R, P0: TaskProtocol, T1, T2> (fn: @escaping (P0.ResultType, T1, T2) throws -> R, args: P0) -> (T1, T2) -> AdapterTask<R> {
    return { a1, a2 in return AdapterTask([args]) { try fn(args.getResult(), a1, a2) } }
}


public func <~ <R: TaskProtocol, T0> (fn: @escaping (T0) -> R, args: T0) -> R {
    return fn(args)
}

public func <~ <R: TaskProtocol, T0, T1> (fn: @escaping (T0, T1) -> R, args: T0) -> (T1) -> R {
    return { a1 in fn(args, a1) }
}

public func <~ <R: TaskProtocol, T0, T1, T2> (fn: @escaping (T0, T1, T2) -> R, args: T0) -> (T1, T2) -> R {
    return { a1, a2 in fn(args, a1, a2) }
}


public func <~ <R: TaskProtocol, T0> (fn: @escaping (T0) throws -> R, args: T0) -> Task<R.ResultType> {
    return AsyncBlockTask { completionHandler in try fn(args).start(completionHandler) }
}

public func <~ <R: TaskProtocol, T0, T1> (fn: @escaping (T0, T1) throws -> R, args: T0) -> (T1) throws -> R {
    return { a1 in try fn(args, a1) }
}

public func <~ <R: TaskProtocol, T0, T1, T2> (fn: @escaping (T0, T1, T2) throws -> R, args: T0) -> (T1, T2) throws -> R {
    return { a1, a2 in try fn(args, a1, a2) }
}


public func <~ <R: TaskProtocol, P0: TaskProtocol> (fn: @escaping (P0.ResultType) throws -> R, args: P0) -> Task<R.ResultType> {
    return AsyncBlockTask { completionHandler in try fn(args.getResult()).start(completionHandler) } ~~ args
}

public func <~ <R: TaskProtocol, P0: TaskProtocol, T1> (fn: @escaping (P0.ResultType, T1) throws -> R, args: P0) -> (T1) -> Task<R.ResultType> {
    return { a1 in return AsyncBlockTask { completionHandler in try fn(args.getResult(), a1).start(completionHandler) } ~~ args }
}

public func <~ <R: TaskProtocol, P0: TaskProtocol, T1, T2> (fn: @escaping (P0.ResultType, T1, T2) throws -> R, args: P0) -> (T1, T2) -> Task<R.ResultType> {
    return { a1, a2 in return AsyncBlockTask { completionHandler in try fn(args.getResult(), a1, a2).start(completionHandler) } ~~ args }
}


public func <~ <R, P0: TaskProtocol> (fn: @escaping (P0.ResultType) throws -> AdapterTask<R>, args: P0) -> AdapterTask<R> {
    return AdapterTask([args]) { try fn(args.getResult()).getResult() }
}

public func <~ <R, P0: TaskProtocol, T1> (fn: @escaping (P0.ResultType, T1) throws -> AdapterTask<R>, args: P0) -> (T1) -> AdapterTask<R> {
    return { a1 in return AdapterTask([args]) { try fn(args.getResult(), a1).getResult() } }
}

public func <~ <R, P0: TaskProtocol, T1, T2> (fn: @escaping (P0.ResultType, T1, T2) throws -> AdapterTask<R>, args: P0) -> (T1, T2) -> AdapterTask<R> {
    return { a1, a2 in return AdapterTask([args]) { try fn(args.getResult(), a1, a2).getResult() } }
}
