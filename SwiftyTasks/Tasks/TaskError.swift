//
//  TaskError.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 11/19/16.
//  Copyright © 2016 address.wtf. All rights reserved.
//

import Foundation

/// Defines possible errors originating from SwiftyTasks library itself
///
/// - genericError: Generic error. You should never get this...
/// - badResult:    Operation returned `nil` for both result and error
/// - noResult:     Operation failed to provide result or error (probably it has not finished yey)
public enum TaskError: Error {
    case genericError
    case badResult
    case noResult
    case cancelled
}
