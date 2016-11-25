//
//  Pending.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 11/25/16.
//  Copyright © 2016 address.wtf. All rights reserved.
//

import Foundation

/// Internal data structure to hold pending value state
///
/// - none:    No value, similar to Optional.none
/// - success: Pending value was computed successfully
/// - error:   Computation failed with an error
enum PendingState<ValueType> {
    case none
    case success(ValueType)
    case error(Error)
}

/// Data structure to hold pending computation result
public final class Pending<ValueType> {
    
    private var _result = PendingState<ValueType>.none
    private let _condition = NSCondition()
    
    /// Sets `Pending` to optional result or error
    ///
    /// - Parameters:
    ///   - result: optional result
    ///   - error: optional error
    public func set(result: ValueType? = nil, error: Error? = nil) {
        _condition.sync {
            guard case .none = _result else {
                fatalError()
            }
            if let error = error {
                _result = .error(error)
            } else if let result = result {
                _result = .success(result)
            } else {
                _result = .error(TaskError.badResult)
            }
            _condition.broadcast()
        }
    }
    
    /// Sets `Pending` to the result of provided block
    ///
    /// - Parameter result: result block
    public func set(_ result: () throws -> ValueType) {
        _condition.sync {
            guard case .none = _result else {
                fatalError()
            }
            do {
                _result = .success(try result())
            } catch {
                _result = .error(error)
            }
            _condition.broadcast()
        }
    }
    
    /// Checks if the value has already been set
    public var isReady: Bool {
        return _condition.sync {
            switch _result {
            case .none: return false
            case .success, .error: return true
            }
        }
    }
    
    /// Retrieves stored value or error
    ///
    /// - Returns: stored value
    /// - Throws: captured error if any
    public func get() throws -> ValueType {
        return try _condition.sync {
            while true {
                switch _result {
                case .none: _condition.wait()
                case .success(let result): return result
                case .error(let error): throw error
                }
            }
        }
    }
    
    /// Waits until value is set
    public func wait() {
        _condition.sync {
            while case .none = _result {
                _condition.wait()
            }
        }
    }
}
