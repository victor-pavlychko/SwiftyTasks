//
//  TestUtils.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 9/23/16.
//  Copyright © 2016 address.wtf. All rights reserved.
//

import XCTest
import SwiftyTasks

fileprivate let expectationQueue = OperationQueue()

extension XCTestCase {
    
    @discardableResult func expectation<T: Operation>(task: T) -> XCTestExpectation {
        let xp = expectation(description: String(describing: T.self))
        let op = BlockOperation { xp.fulfill() }
        op.addDependency(task)
        expectationQueue.addOperation(op)
        return xp
    }
    
    func waitForExpectations(_ code: @escaping () -> Void) {
        waitForExpectations(timeout: 60) { error in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
            code()
        }
        
    }
}
