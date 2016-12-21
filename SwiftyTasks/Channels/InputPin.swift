//
//  InputPin.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 9/30/16.
//  Copyright © 2016 address.wtf. All rights reserved.
//

import Foundation

/// <#Description#>
public final class InputPin<Element>: Sequence, IteratorProtocol {
    
    private var _attached = false
    private var _next: (() -> Element?)?
    private let _condition = NSCondition()

    /// <#Description#>
    ///
    /// - Parameter channel: <#channel description#>
    public func attach<T: IteratorProtocol>(_ channel: T?) where T.Element == Element {
        _condition.sync {
            guard !_attached else {
                fatalError()
            }
            if var channel = channel {
                _next =  { channel.next() }
            }
            _attached = true
            _condition.broadcast()
        }
    }

    /// <#Description#>
    ///
    /// - Returns: <#return value description#>
    public func next() -> Element? {
        return _condition.sync {
            while true {
                guard _attached else {
                    _condition.wait()
                    continue
                }
                return _next?()
            }
        }
    }
}
