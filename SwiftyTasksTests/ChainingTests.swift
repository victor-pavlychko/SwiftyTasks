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
        
        waitForExpectations {
            do {
                let result1 = try task1.getResult()
                XCTAssertEqual(result1, "Success1")
                let result2 = try task2.getResult()
                XCTAssertEqual(result2, "Success2")
            } catch {
                XCTFail(error.localizedDescription)
            }
        }
    }
    
    func concatenateTask(s1: String, s2: String) -> DemoTask<String> {
        return DemoTask(.success(s1 + s2))
    }
    
    func testComplexChain() {
        
        let waitQueue = OperationQueue()
        let taskQueue = OperationQueue()
        
        let waitOperation = waitQueue
            += BlockOperation { sleep(20) }

        let taskPart1 = taskQueue
            += DemoTask.init(_:)
            <~ .success("Suc")
        
        let taskPart2 = taskQueue
            += DemoAsyncTask.init(_:)
            <~ .success("cess")
        
        let task1 = taskQueue
            += concatenateTask(s1:s2:)
            <~ taskPart1
            <~ taskPart2
            ~~ waitOperation
        
        let task2 = taskQueue
            += DemoTask.init(_:)
            <~ (taskPart1, taskPart2) ~> { .success($0 + $1) }
            ~~ waitOperation

        expectation(task: task1)
        expectation(task: task2)
        
        waitForExpectations {
            do {
                XCTAssert(waitOperation.isFinished)
                let result1 = try task1.getResult()
                XCTAssertEqual(result1, dummyResult)
                let result2 = try task2.getResult()
                XCTAssertEqual(result2, dummyResult)
            } catch {
                XCTFail(error.localizedDescription)
            }
        }
    }

}
