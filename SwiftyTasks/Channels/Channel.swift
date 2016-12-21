//
//  Channels.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 9/28/16.
//  Copyright © 2016 address.wtf. All rights reserved.
//

import Foundation

/// <#Description#>
public final class Channel<Element>: OutputChannel, Sequence, IteratorProtocol {

    private var _active = true
    private var _buffer: [Element] = []
    private let _bufferLimit: Int
    private let _condition = NSCondition()
    
    /// <#Description#>
    ///
    /// - Parameter bufferSize: <#bufferSize description#>
    public init(bufferSize: Int? = 0) {
        switch bufferSize {
        case .none:
            _bufferLimit = Int.max
        case let .some(bufferSize) where bufferSize >= 0:
            _bufferLimit = bufferSize + 1
        default:
            fatalError()
        }
    }

    /// <#Description#>
    ///
    /// - Parameter element: <#element description#>
    /// - Returns: <#return value description#>
    @discardableResult
    public func send(_ element: Element) -> Bool {
        return _condition.sync {
            while true {
                guard _active else {
                    return false
                }
                guard _buffer.count < _bufferLimit else {
                    _condition.wait()
                    continue
                }
                _buffer.append(element)
                _condition.broadcast()
                return true
            }
        }
    }

    /// <#Description#>
    public func close() {
        _condition.sync {
            guard _active else {
                fatalError()
            }
            _active = false
            _condition.broadcast()
        }
    }

    /// <#Description#>
    ///
    /// - Returns: <#return value description#>
    public func next() -> Element? {
        return _condition.sync {
            while true {
                guard _active else {
                    return nil
                }
                guard let result = _buffer.first else {
                    _condition.wait()
                    continue
                }
                _buffer.removeFirst()
                _condition.broadcast()
                return result
            }
        }
    }
}
