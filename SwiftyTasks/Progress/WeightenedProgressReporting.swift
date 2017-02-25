//
//  WeightenedProgressReporting.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 2/24/17.
//  Copyright © 2017 address.wtf. All rights reserved.
//

import Foundation

public struct ProgressWeight: RawRepresentable, ExpressibleByIntegerLiteral {
    
    public let rawValue: Int64
    
    public init(rawValue: Int64) {
        self.rawValue = rawValue
    }
    
    public init(integerLiteral value: Int64) {
        rawValue = value
    }
}

public extension ProgressWeight {
    
    public static let instant = ProgressWeight(rawValue: 5)
    public static let normal = ProgressWeight(rawValue: 100)
    public static let epic = ProgressWeight(rawValue: 1000)

    public static let `default` = ProgressWeight.normal
}

public protocol WeightenedProgressReporting: ProgressReporting {
    
    static var progressWeight: ProgressWeight { get }
    var progressWeight: ProgressWeight { get }
}

public extension WeightenedProgressReporting {
    
    public var progressWeight: ProgressWeight {
        return Self.progressWeight
    }
}
