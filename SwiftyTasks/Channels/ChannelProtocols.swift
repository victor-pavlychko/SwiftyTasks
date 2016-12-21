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
