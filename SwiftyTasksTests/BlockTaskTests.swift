//
//  BlockTaskTests.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 9/23/16.
//  Copyright © 2016 address.wtf. All rights reserved.
//

import XCTest
@testable import SwiftyTasks

class BlockTaskTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testSyncSuccess() {
        
        let task = BlockTask { return dummyResult }
        expectation(task: task)
        
        let queue = OperationQueue()
        queue.addOperation(task)
        
        waitForExpectations {
            do {
                let result = try task.getResult()
                XCTAssertEqual(result, dummyResult)
            } catch {
                XCTFail(error.localizedDescription)
            }
        }
    }
    
    func testSyncError() {
        
        let task = BlockTask { throw dummyError }
        expectation(task: task)
        
        let queue = OperationQueue()
        queue.addOperation(task)
        
        waitForExpectations {
            do {
                let _ = try task.getResult()
                XCTFail()
            } catch {
                XCTAssertEqual(error as? DemoError, dummyError)
            }
        }
    }
    
    func testSyncOptional_None() {
        
        let task = BlockTask<String> { return nil }
        expectation(task: task)
        
        let queue = OperationQueue()
        queue.addOperation(task)
        
        waitForExpectations {
            do {
                let _ = try task.getResult()
                XCTFail()
            } catch {
                XCTAssertEqual(error as? OperationError, OperationError.badResult)
            }
        }
    }

}
