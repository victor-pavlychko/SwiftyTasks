//
//  AsyncBlockTask.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 9/12/16.
//  Copyright © 2016 address.wtf. All rights reserved.
//

import Foundation

/// The AsyncBlockTask class implements AsyncTask wrapping concrete code block
public final class AsyncBlockTask<ResultType>: AsyncTask<ResultType> {

    private var _block: ((AsyncBlockTask<ResultType>) throws -> Void)!
    
    /// <#Description#>
    ///
    /// - parameter block: <#block description#>
    ///
    /// - returns: <#return value description#>
    init(_ block: @escaping (@escaping (ResultType) -> Void) throws -> Void) {
        _block = { try block($0.finish) }
    }
    
    /// <#Description#>
    ///
    /// - parameter block: <#block description#>
    ///
    /// - returns: <#return value description#>
    init(_ block: @escaping (@escaping (ResultType?, Error?) -> Void) throws -> Void) {
        _block = { try block($0.finish) }
    }
    
    /// <#Description#>
    ///
    /// - parameter block: <#block description#>
    ///
    /// - returns: <#return value description#>
    init(_ block: @escaping (@escaping (ResultType?) -> Void) throws -> Void) {
        _block = { try block($0.finish) }
    }
    
    /// <#Description#>
    ///
    /// - parameter block: <#block description#>
    ///
    /// - returns: <#return value description#>
    init(_ block: @escaping (@escaping (() throws -> ResultType) -> Void) throws -> Void) {
        _block = { try block($0.finish) }
    }
    
    /// <#Description#>
    public override func main() {
        do {
            try _block(self)
            _block = nil
        } catch {
            finish(error: error)
        }
    }
}
