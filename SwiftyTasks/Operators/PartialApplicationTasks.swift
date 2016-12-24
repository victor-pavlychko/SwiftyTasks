//
//  PartialApplication.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 9/18/16.
//  Copyright © 2016 address.wtf. All rights reserved.
//

import Foundation

public struct TaskPartialApplication1<R, T1> {
    fileprivate let deps: [AnyTask]
    fileprivate let fn: (T1) throws -> Task<R>
}

public struct TaskPartialApplication2<R, T1, T2> {
    fileprivate let deps: [AnyTask]
    fileprivate let fn: (T1, T2) throws -> Task<R>
}

// MARK: function + task

public func <~ <R, P0> (fn: @escaping (P0.ResultType) throws -> R, args: P0) -> Task<R> where P0: TaskProtocol {
    return BlockTask { try fn(args.getResult()) } ~~ args
}

public func <~ <R, P0, T1> (fn: @escaping (P0.ResultType, T1) throws -> R, args: P0) -> TaskPartialApplication1<R, T1> where P0: TaskProtocol {
    return TaskPartialApplication1(deps: [args]) { a1 in BlockTask { try fn(args.getResult(), a1) } }
}

public func <~ <R, P0, T1, T2> (fn: @escaping (P0.ResultType, T1, T2) throws -> R, args: P0) -> TaskPartialApplication2<R, T1, T2> where P0: TaskProtocol {
    return TaskPartialApplication2(deps: [args]) { a1, a2 in BlockTask { try fn(args.getResult(), a1, a2) } }
}

// MARK: task + value

public func <~ <R, T0> (fn: @escaping (T0) throws -> R, args: T0) -> Task<R.ResultType> where R: TaskProtocol {
    return AsyncBlockTask { completion in try fn(args).start(completion) }
}

public func <~ <R, T0, T1> (fn: @escaping (T0, T1) throws -> R, args: T0) -> TaskPartialApplication1<R.ResultType, T1> where R: TaskProtocol {
    return TaskPartialApplication1(deps: []) { a1 in AsyncBlockTask { completion in try fn(args, a1).start(completion) } }
}

public func <~ <R, T0, T1, T2> (fn: @escaping (T0, T1, T2) throws -> R, args: T0) -> TaskPartialApplication2<R.ResultType, T1, T2> where R: TaskProtocol {
    return TaskPartialApplication2(deps: []) { a1, a2 in AsyncBlockTask { completion in try fn(args, a1, a2).start(completion) } }
}

// MARK: task + task

public func <~ <R, P0> (fn: @escaping (P0.ResultType) throws -> R, args: P0) -> Task<R.ResultType> where R: TaskProtocol, P0: TaskProtocol {
    return AsyncBlockTask { completion in try fn(args.getResult()).start(completion) } ~~ args
}

public func <~ <R, P0, T1> (fn: @escaping (P0.ResultType, T1) throws -> R, args: P0) -> TaskPartialApplication1<R.ResultType, T1> where R: TaskProtocol, P0: TaskProtocol {
    return TaskPartialApplication1(deps: [args]) { a1 in AsyncBlockTask { completion in try fn(args.getResult(), a1).start(completion) } }
}

public func <~ <R, P0, T1, T2> (fn: @escaping (P0.ResultType, T1, T2) throws -> R, args: P0) -> TaskPartialApplication2<R.ResultType, T1, T2> where R: TaskProtocol, P0: TaskProtocol {
    return TaskPartialApplication2(deps: [args]) { a1, a2 in AsyncBlockTask { completion in try fn(args.getResult(), a1, a2).start(completion) } }
}

// MARK: partial + value

public func <~ <R, T0> (app: TaskPartialApplication1<R, T0>, args: T0) -> Task<R> {
    return AsyncBlockTask { completion in try app.fn(args).start(completion) } ~~ app.deps
}

public func <~ <R, T0, T1> (app: TaskPartialApplication2<R, T0, T1>, args: T0) -> TaskPartialApplication1<R, T1> {
    return TaskPartialApplication1(deps: app.deps) { a1 in try app.fn(args, a1) }
}

// MARK: partial + task

public func <~ <R, P0> (app: TaskPartialApplication1<R, P0.ResultType>, args: P0) -> Task<R> where P0: TaskProtocol {
    return AsyncBlockTask { completion in try app.fn(args.getResult()).start(completion) } ~~ app.deps ~~ args
}

public func <~ <R, P0, T1> (app: TaskPartialApplication2<R, P0.ResultType, T1>, args: P0) -> TaskPartialApplication1<R, T1> where P0: TaskProtocol {
    return TaskPartialApplication1(deps: app.deps.appending(args)) { a1 in try app.fn(args.getResult(), a1) }
}
