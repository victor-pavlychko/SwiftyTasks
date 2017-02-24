//
//  WeightenedProgressReporting.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 2/24/17.
//  Copyright © 2017 address.wtf. All rights reserved.
//

import Foundation

public struct ProgressWeight: RawRepresentable {
    
    public let rawValue: Int64
    
    public init(rawValue: Int64) {
        self.rawValue = rawValue
    }
}

public extension ProgressWeight {
    
    public static let instant = ProgressWeight(rawValue: 1)
    public static let normal = ProgressWeight(rawValue: 10)
    public static let epic = ProgressWeight(rawValue: 100)

    public static let `default` = ProgressWeight.normal
}

public protocol WeightenedProgressReporting: ProgressReporting {

    var progressWight: ProgressWeight { get }
}
