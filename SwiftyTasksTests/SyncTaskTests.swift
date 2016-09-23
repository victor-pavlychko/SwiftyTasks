//
//  SyncTaskTests.swift
//  SwiftyTasksTests
//
//  Created by Victor Pavlychko on 9/19/16.
//  Copyright © 2016 address.wtf. All rights reserved.
//

import XCTest
@testable import SwiftyTasks

class SyncTaskTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testSuccess() {
        
        let xp = expectation(description: "")
        let queue = OperationQueue()
        
        let task = DemoAsyncTask(.success(dummyResult))
        
        task.completionBlock = {
            xp.fulfill()
        }
        
        queue.addOperation(task)
        
        waitForExpectations {
            do {
                XCTAssertEqual(try task.getResult(), dummyResult)
            } catch {
                XCTFail(error.localizedDescription)
            }
        }
    }
    
    func testError() {
        
        let xp = expectation(description: "")
        let queue = OperationQueue()
        
        let task = DemoAsyncTask(DemoTaskResult<String>.error(dummyError))
        
        task.completionBlock = {
            xp.fulfill()
        }
        
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
    
    func testSuccessOrError_Success() {
        
        let xp = expectation(description: "")
        let queue = OperationQueue()
        
        let task = DemoAsyncTask(.successOrError(dummyResult, nil))
        
        task.completionBlock = {
            xp.fulfill()
        }
        
        queue.addOperation(task)
        
        waitForExpectations {
            do {
                XCTAssertEqual(try task.getResult(), dummyResult)
            } catch {
                XCTFail(error.localizedDescription)
            }
        }
    }
    
    func testSuccessOrError_Error() {
        
        let xp = expectation(description: "")
        let queue = OperationQueue()
        
        let task = DemoAsyncTask(DemoTaskResult<String>.successOrError(nil, dummyError))
        
        task.completionBlock = {
            xp.fulfill()
        }
        
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
    
    func testOptionalSuccess_Some() {
        
        let xp = expectation(description: "")
        let queue = OperationQueue()
        
        let task = DemoAsyncTask(.optionalSuccess(dummyResult))
        
        task.completionBlock = {
            xp.fulfill()
        }
        
        queue.addOperation(task)
        
        waitForExpectations {
            do {
                XCTAssertEqual(try task.getResult(), dummyResult)
            } catch {
                XCTFail(error.localizedDescription)
            }
        }
    }
    
    func testOptionalSuccess_None() {
        
        let xp = expectation(description: "")
        let queue = OperationQueue()
        
        let task = DemoAsyncTask(DemoTaskResult<String>.optionalSuccess(nil))
        
        task.completionBlock = {
            xp.fulfill()
        }
        
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
    
    func testResultBlock_Success() {
        
        let xp = expectation(description: "")
        let queue = OperationQueue()
        
        let task = DemoAsyncTask(.resultBlock({ return dummyResult }))
        
        task.completionBlock = {
            xp.fulfill()
        }
        
        queue.addOperation(task)
        
        waitForExpectations {
            do {
                XCTAssertEqual(try task.getResult(), dummyResult)
            } catch {
                XCTFail(error.localizedDescription)
            }
        }
    }
    
    func testResultBlock_Error() {
        
        let xp = expectation(description: "")
        let queue = OperationQueue()
        
        let task = DemoAsyncTask(DemoTaskResult<String>.resultBlock({ throw dummyError }))
        
        task.completionBlock = {
            xp.fulfill()
        }
        
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
    
}
