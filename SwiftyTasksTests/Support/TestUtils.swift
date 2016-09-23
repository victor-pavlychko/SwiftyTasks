//
//  TestUtils.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 9/23/16.
//  Copyright © 2016 address.wtf. All rights reserved.
//

import XCTest
import SwiftyTasks

extension XCTestCase {
    
    @discardableResult func expectation<T: Operation>(task: T) -> XCTestExpectation {
        let xp = expectation(description: String(describing: T.self))
        task.completionBlock = {
            xp.fulfill()
        }
        
        return xp
    }
}
