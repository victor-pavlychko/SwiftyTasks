//
//  InputPin.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 9/30/16.
//  Copyright © 2016 address.wtf. All rights reserved.
//

import Foundation

/// <#Description#>
public final class InputPin<ElementType>: InputChannel {
    
    private var _attached = false
    private var _recv: (() -> ElementType?)?
    private let _condition = NSCondition()

    /// <#Description#>
    ///
    /// - Parameter channel: <#channel description#>
    public func attach<T: InputChannel>(_ channel: T?) where T.ElementType == ElementType {
        _condition.sync {
            guard !_attached else {
                fatalError()
            }
            _attached = true
            _recv = channel?.recv
            _condition.broadcast()
        }
    }
    
    /// <#Description#>
    ///
    /// - Returns: <#return value description#>
    public func recv() -> ElementType? {
        return _condition.sync {
            while true {
                guard _attached else {
                    _condition.wait()
                    continue
                }
                return _recv?()
            }
        }
    }
}
