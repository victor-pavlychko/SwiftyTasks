//
//  ArrayExtensions.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 12/24/16.
//  Copyright © 2016 address.wtf. All rights reserved.
//

import Foundation

internal extension Array {
    
    /// <#Description#>
    ///
    /// - Parameter element: <#element description#>
    /// - Returns: <#return value description#>
    internal func appending(_ element: Element) -> [Element] {
        return self + [element]
    }
    
    /// <#Description#>
    ///
    /// - Parameter elements: <#elements description#>
    /// - Returns: <#return value description#>
    internal func appending(_ elements: [Element]) -> [Element] {
        return self + elements
    }
    
    /// <#Description#>
    ///
    /// - Parameter elements: <#elements description#>
    /// - Returns: <#return value description#>
    internal func appending<S>(_ elements: S) -> [Element] where S: Sequence, S.Iterator.Element == Element {
        return self + elements.map { $0 }
    }
}
