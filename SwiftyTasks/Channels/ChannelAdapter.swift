//
//  ChannelAdapter.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 12/22/16.
//  Copyright © 2016 address.wtf. All rights reserved.
//

import Foundation

/// <#Description#>
public final class ChannelAdapter<Base, Element>: Sequence, IteratorProtocol where Base: IteratorProtocol {

    private var _base: Base
    private let _transform: (Base.Element) -> Element

    /// <#Description#>
    ///
    /// - Parameters:
    ///   - base: <#base description#>
    ///   - transform: <#transform description#>
    ///   - element: <#transform description#>
    public init(base: Base, transform: @escaping (_ element: Base.Element) -> Element) {
        _base = base
        _transform = transform
    }
    
    /// <#Description#>
    ///
    /// - Returns: <#return value description#>
    public func next() -> Element? {
        guard let element = _base.next() else {
            return nil
        }
        return _transform(element)
    }
}

public extension IteratorProtocol {
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - transform: <#transform description#>
    ///   - element: <#transform description#>
    /// - Returns: <#return value description#>
    public func transform<T>(_ transform: @escaping (_ element: Element) -> T) -> ChannelAdapter<Self, T> {
        return ChannelAdapter(base: self, transform: transform)
    }
}
