//
//  ChannelProtocols.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 9/30/16.
//  Copyright © 2016 address.wtf. All rights reserved.
//

import Foundation

/// <#Description#>
public protocol OutputChannel {
    
    /// <#Description#>
    associatedtype ElementType
    
    /// <#Description#>
    ///
    /// - Parameter element: <#element description#>
    /// - Returns: <#return value description#>
    @discardableResult
    func send(_ element: ElementType) -> Bool
    
    /// <#Description#>
    func close()
}

/// <#Description#>
public protocol InputChannel: Sequence, IteratorProtocol {
    
    /// <#Description#>
    associatedtype ElementType
    
    /// <#Description#>
    ///
    /// - Returns: <#return value description#>
    func recv() -> ElementType?
}

// <#Description#>
extension InputChannel {
    
    /// <#Description#>
    ///
    /// - Returns: <#return value description#>
    public func makeIterator() -> Self {
        return self
    }

    /// <#Description#>
    ///
    /// - Returns: <#return value description#>
    public func next() -> ElementType? {
        return recv()
    }
}
