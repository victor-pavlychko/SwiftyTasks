//
//  OutputPin.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 9/30/16.
//  Copyright © 2016 address.wtf. All rights reserved.
//

import Foundation

/// <#Description#>
public final class OutputPin<Element>: OutputChannel {
    
    private var _attached = false
    private var _send: ((Element) -> Bool)?
    private var _close: (() -> Void)?
    private let _condition = NSCondition()

    /// <#Description#>
    public init() {
    }

    /// <#Description#>
    ///
    /// - Parameter channel: <#channel description#>
    public func attach<T: OutputChannel>(_ channel: T?) where T.Element == Element {
        _condition.sync {
            guard !_attached else {
                fatalError()
            }
            _attached = true
            _send = channel?.send(_:)
            _close = channel?.close
            _condition.broadcast()
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
                guard _attached else {
                    _condition.wait()
                    continue
                }
                return _send?(element) ?? true
            }
        }
    }
    
    /// <#Description#>
    public func close() {
        _condition.sync {
            while true {
                guard _attached else {
                    _condition.wait()
                    continue
                }
                _close?()
                return
            }
        }
    }
}
