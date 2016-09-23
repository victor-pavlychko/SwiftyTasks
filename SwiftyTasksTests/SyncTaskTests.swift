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
        
        let task = DemoTask(.success(dummyResult))
        expectation(task: task)
        
        let queue = OperationQueue()
        queue.addOperation(task)
        
        waitForExpectations(timeout: 60) { error in
            do {
                XCTAssertEqual(try task.getResult(), dummyResult)
            } catch {
                XCTFail(error.localizedDescription)
            }
        }
    }
    
    func testError() {
        
        let task = DemoTask(DemoTaskResult<String>.error(dummyError))
        expectation(task: task)
        
        let queue = OperationQueue()
        queue.addOperation(task)
        
        waitForExpectations(timeout: 60) { error in
            do {
                let _ = try task.getResult()
                XCTFail()
            } catch {
                XCTAssertEqual(error as? DemoError, dummyError)
            }
        }
    }
    
    func testSuccessOrError_Success() {
        
        let task = DemoTask(.successOrError(dummyResult, nil))
        expectation(task: task)
        
        let queue = OperationQueue()
        queue.addOperation(task)
        
        waitForExpectations(timeout: 60) { error in
            do {
                XCTAssertEqual(try task.getResult(), dummyResult)
            } catch {
                XCTFail(error.localizedDescription)
            }
        }
    }
    
    func testSuccessOrError_Error() {
        
        let task = DemoTask(DemoTaskResult<String>.successOrError(nil, dummyError))
        expectation(task: task)
        
        let queue = OperationQueue()
        queue.addOperation(task)
        
        waitForExpectations(timeout: 60) { error in
            do {
                let _ = try task.getResult()
                XCTFail()
            } catch {
                XCTAssertEqual(error as? DemoError, dummyError)
            }
        }
    }
    
    func testOptionalSuccess_Some() {
        
        let task = DemoTask(.optionalSuccess(dummyResult))
        expectation(task: task)
        
        let queue = OperationQueue()
        queue.addOperation(task)
        
        waitForExpectations(timeout: 60) { error in
            do {
                XCTAssertEqual(try task.getResult(), dummyResult)
            } catch {
                XCTFail(error.localizedDescription)
            }
        }
    }
    
    func testOptionalSuccess_None() {
        
        let task = DemoTask(DemoTaskResult<String>.optionalSuccess(nil))
        expectation(task: task)
        
        let queue = OperationQueue()
        queue.addOperation(task)
        
        waitForExpectations(timeout: 60) { error in
            do {
                let _ = try task.getResult()
                XCTFail()
            } catch {
                XCTAssertEqual(error as? OperationError, OperationError.badResult)
            }
        }
    }
    
    func testResultBlock_Success() {
        
        let task = DemoTask(.resultBlock({ return dummyResult }))
        expectation(task: task)
        
        let queue = OperationQueue()
        queue.addOperation(task)
        
        waitForExpectations(timeout: 60) { error in
            do {
                XCTAssertEqual(try task.getResult(), dummyResult)
            } catch {
                XCTFail(error.localizedDescription)
            }
        }
    }
    
    func testResultBlock_Error() {
        
        let task = DemoTask(DemoTaskResult<String>.resultBlock({ throw dummyError }))
        expectation(task: task)
        
        let queue = OperationQueue()
        queue.addOperation(task)
        
        waitForExpectations(timeout: 60) { error in
            do {
                let _ = try task.getResult()
                XCTFail()
            } catch {
                XCTAssertEqual(error as? DemoError, dummyError)
            }
        }
    }
    
}
