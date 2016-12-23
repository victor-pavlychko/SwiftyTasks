//
//  OutputChannel.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 9/30/16.
//  Copyright © 2016 address.wtf. All rights reserved.
//

import Foundation

/// <#Description#>
public protocol OutputChannel {
    
    /// <#Description#>
    associatedtype Element
    
    /// <#Description#>
    ///
    /// - Parameter element: <#element description#>
    /// - Returns: <#return value description#>
    @discardableResult
    func send(_ element: Element) -> Bool
    
    /// <#Description#>
    func close()
}

/// <#Description#>
public final class AnyOutputChannel<Element>: OutputChannel {
    
    private let _box: _AnyOutputChannelBox<Element>
    
    /// <#Description#>
    ///
    /// - Parameter base: <#base description#>
    public init<Base>(_ base: Base) where Base: OutputChannel, Base.Element == Element {
        _box = _AnyOutputChannelBoxImpl(base)
    }

    /// <#Description#>
    ///
    /// - Parameter element: <#element description#>
    /// - Returns: <#return value description#>
    @discardableResult
    public func send(_ element: Element) -> Bool {
        return _box.send(element)
    }
    
    /// <#Description#>
    public func close() {
        _box.close()
    }
}

fileprivate class _AnyOutputChannelBox<Element>: OutputChannel {
    
    @discardableResult
    fileprivate func send(_ element: Element) -> Bool {
        fatalError()
    }
    
    fileprivate func close() {
        fatalError()
    }
}

fileprivate final class _AnyOutputChannelBoxImpl<Base>: _AnyOutputChannelBox<Base.Element> where Base: OutputChannel {

    private let _base: Base
    
    init(_ base: Base) {
        _base = base
    }
    
    @discardableResult
    fileprivate override func send(_ element: Base.Element) -> Bool {
        return _base.send(element)
    }
    
    fileprivate override func close() {
        _base.close()
    }
}
