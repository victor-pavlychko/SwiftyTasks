//
//  TaskIO.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 9/18/16.
//  Copyright © 2016 address.wtf. All rights reserved.
//

import Foundation

public protocol Consumer
{
    associatedtype ItemType
    func consume(_ item: ItemType?)
}

public protocol Producer: Consumer
{
    associatedtype ItemType
    func addConsumer<C: Consumer>(_ consumer: C) where C.ItemType == ItemType
    func produce(_ item: ItemType?)
}

public extension Producer {
    public func consume(_ item: ItemType?) {
        produce(item)
    }
}

public struct AnyConsumer<ItemType>: Consumer
{
    private let _consume: (ItemType?) -> Void
    
    init<C: Consumer>(_ consumer: C) where C.ItemType == ItemType {
        _consume = consumer.consume(_:)
    }

    public func consume(_ item: ItemType?) {
        _consume(item)
    }
}

public struct BlockConsumer<ItemType>: Consumer {

    private let _consume: (ItemType?) -> Void
    
    init<C: Consumer>(_ consume: @escaping (ItemType?) -> Void) where C.ItemType == ItemType {
        _consume = consume
    }
    
    public func consume(_ item: ItemType?) {
        _consume(item)
    }
}

public final class TaskOutput<ItemType>: Producer
{
    private var _consumers: [AnyConsumer<ItemType>] = []
    
    public func addConsumer<C: Consumer>(_ consumer: C) where C.ItemType == ItemType {
        _consumers.append(.init(consumer))
    }

    public func produce(_ item: ItemType?) {
        _consumers.forEach {
            $0.consume(item)
        }
    }

    public func finish() {
    }
}

public func += <P: Producer, C: Consumer> (lhs: P, rhs: C) where P.ItemType == C.ItemType {
    lhs.addConsumer(rhs)
}

public func <- <P: Producer, C: Consumer> (lhs: C, rhs: P) where P.ItemType == C.ItemType {
    rhs.addConsumer(lhs)
}





