//
//  InputChannel.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 12/23/16.
//  Copyright © 2016 address.wtf. All rights reserved.
//

import Foundation

/// <#Description#>
public final class AnyInputChannel<Element>: Sequence, IteratorProtocol {
    
    private let _box: _AnyInputChannelBox<Element>

    /// <#Description#>
    ///
    /// - Parameter base: <#base description#>
    public init<Base>(_ base: Base) where Base: IteratorProtocol, Base.Element == Element {
        _box = _AnyInputChannelBoxImpl(base)
    }

    /// <#Description#>
    ///
    /// - Returns: <#return value description#>
    public func next() -> Element? {
        return _box.next()
    }
}

fileprivate class _AnyInputChannelBox<Element>: IteratorProtocol {

    fileprivate func next() -> Element? {
        fatalError()
    }
}

fileprivate final class _AnyInputChannelBoxImpl<Base>: _AnyInputChannelBox<Base.Element> where Base: IteratorProtocol {
    
    private var _base: Base
    
    init(_ base: Base) {
        _base = base
    }
    
    fileprivate override func next() -> Base.Element? {
        return _base.next()
    }
}
