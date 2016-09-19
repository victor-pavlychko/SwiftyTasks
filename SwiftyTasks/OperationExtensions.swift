//
//  OperationExtensions.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 9/12/16.
//  Copyright © 2016 address.wtf. All rights reserved.
//

import Foundation

public extension Operation {
    public func purgeDependencies() {
        dependencies.forEach(removeDependency)
    }
}
