# SwiftyTasks

[![CI Status](http://img.shields.io/travis/victor-pavlychko/SwiftyTasks.svg?style=flat)](https://travis-ci.org/victor-pavlychko/SwiftyTasks)
[![Pod Version](https://img.shields.io/cocoapods/v/SwiftyTasks.svg?style=flat)](http://cocoapods.org/pods/SwiftyTasks)
[![Carthage: compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License: MIT](https://img.shields.io/badge/license-MIT-3b3b3b.svg?style=flat)](https://github.com/victor-pavlychko/SwiftyTasks/blob/master/LICENSE)
[![Swift: 3.0](https://img.shields.io/badge/swift-3.0-orange.svg?style=flat)](https://github.com/victor-pavlychko/SwiftyTasks)
[![Platform: iOS](https://img.shields.io/badge/platform-ios-lightgrey.svg?style=flat)](https://github.com/victor-pavlychko/SwiftyTasks)

## Overview

Most task/operation manadgement libraries either build task infrastructure from scratch or
focus on defining custom `Operation` subclasses.

SwiftyTask aims to build workflows on top of existing `Operation` infrastructure extending
it with result/error handling. Any third-parrty `Operation` subclasses can be easily extended
to support `TaskProtocol` and participate in complex workflows.

### Tasks

SwiftyTasks defines following task-related protocols:
* `AnyTaskProtocol`: provides list of backing tasks, is adopted by `Operation` class
* `TaskProtocol`: extenda `AnyTaskProtocol` adding access to execution result

Library also defines following task-related classes:
* `Task<ResultType>`: base class, conforms to `TaskProtocol`, provides result handling
* `BlockTask<ResultType>`: subclass to wrap any code block into a `Task`
* `AsyncTask<ResultType>`: extenda `Task` class with asynchronous `Operation` state handling
* `AsyncBlockTask<ResultType>`: subclass to wrap any asynchronous code block into an `AsyncTask`
* `AdapterTask<ResultType>`: subclass wrapping list on operations custom result block

### Operators

Following operators are defined to manage tasks:
* `+=`: enqueue task in OperationQueue
* `<~`: performs partial function application where operand on the right may be either value or task
* `~>`: performs deferred function call given value/task list on the right
* `~~`: adds task on the right as a dependency to task on the left

### Partial Application

`Task` workflows circulate around partial application and functions returning `Task`s.

Use `<~` operator to perform partial application. Function on the left will be wrapped into a task
scheduled to be executed after value on the right is ready.

Use `~>` operator to convert list of values. Function on the right will be wrapped into a task
scheduled to be executed when all values on the left are ready.

Finally `+=` operator is overloaded to enqueue tasks into `OperationQueue`

## Real-world Example

Following is an example of real-world use to create video,
save it to photo library and put into a gallery folder.

```swift
let createVideoOperation = OperationQueue.main
    += CreateVideoOperation()

let createVideoAssetOperation = OperationQueue.main
    += CreateVideoAssetOperation.init(videoURL:)
    <~ createVideoOperation

let createAssetCollectionOperation = OperationQueue.main
    += CreateAssetCollectionOperation.init(title:)
    <~ "Convenience"

let addAssetToCollectionOperation = OperationQueue.main
    += AddAssetToCollectionOperation.init(asset:collection:)
    <~ createVideoAssetOperation
    <~ createAssetCollectionOperation

addAssetToCollectionOperation.completionBlock = {
    completionBlock()
}
```

## Installation

SwiftyTasks is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "SwiftyTasks"
```

## Author

Victor Pavlychko, victor.pavlychko@gmail.com

## License

SwiftyTasks is available under the MIT license. See the LICENSE file for more info.
