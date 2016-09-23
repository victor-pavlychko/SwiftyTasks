//
//  ChainingTests.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 9/23/16.
//  Copyright © 2016 address.wtf. All rights reserved.
//

import XCTest
@testable import SwiftyTasks

class ChainingTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testTaskTaskDependency() {
        
        let task1 = DemoTask(.success("Success1"))
        let task2 = DemoTask(.success("Success2")) ~~ task1
        
        XCTAssert(task2.dependencies.contains(task1))
        
        expectation(task: task1)
        expectation(task: task2)
        
        let queue = OperationQueue()
        queue.addOperation(task1)
        queue.addOperation(task2)
        
        waitForExpectations(timeout: 60) { error in
            do {
                try XCTAssertEqual(task1.getResult(), "Success1")
                try XCTAssertEqual(task2.getResult(), "Success2")
            } catch {
                XCTFail(error.localizedDescription)
            }
        }
    }

}
