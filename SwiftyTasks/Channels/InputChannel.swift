//
//  InputChannel.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 12/23/16.
//  Copyright © 2016 address.wtf. All rights reserved.
//

import Foundation

/// <#Description#>
public protocol InputChannel: IteratorProtocol {
    
    /// <#Description#>
    func close()
}

public extension InputChannel {
    
    func close() { }
}

/// <#Description#>
public final class AnyInputChannel<Element>: Sequence, InputChannel {
    
    private let _box: _AnyInputChannelBox<Element>

    /// <#Description#>
    ///
    /// - Parameter base: <#base description#>
    public init<Base>(_ base: Base) where Base: InputChannel, Base.Element == Element {
        _box = _AnyInputChannelBoxImpl(base)
    }
    
    /// <#Description#>
    ///
    /// - Parameter base: <#base description#>
    public init<Base>(_ base: Base) where Base: IteratorProtocol, Base.Element == Element {
        _box = _AnyInputChannelIteratorBoxImpl(base)
    }

    /// <#Description#>
    ///
    /// - Returns: <#return value description#>
    public func next() -> Element? {
        return _box.next()
    }

    /// <#Description#>
    public func close() {
        _box.close()
    }
}

fileprivate class _AnyInputChannelBox<Element>: InputChannel {
    
    fileprivate func next() -> Element? {
        fatalError()
    }
    
    fileprivate func close() {
        fatalError()
    }
}

fileprivate class _AnyInputChannelIteratorBoxImpl<Base>: _AnyInputChannelBox<Base.Element> where Base: IteratorProtocol {
    
    fileprivate var _base: Base
    
    fileprivate init(_ base: Base) {
        _base = base
    }
    
    fileprivate override func next() -> Base.Element? {
        return _base.next()
    }
    
    fileprivate override func close() {
    }
}

fileprivate final class _AnyInputChannelBoxImpl<Base>: _AnyInputChannelIteratorBoxImpl<Base> where Base: InputChannel {
    
    fileprivate override func close() {
        _base.close()
    }
}
