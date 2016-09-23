//
//  TaskOperators.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 9/18/16.
//  Copyright © 2016 address.wtf. All rights reserved.
//

import Foundation

precedencegroup PartialApplicationPrecedence {
    associativity: left
    higherThan: AssignmentPrecedence
}

precedencegroup ReverseApplicationPrecedence {
    associativity: left
    higherThan: PartialApplicationPrecedence
}

///
infix operator <~ : PartialApplicationPrecedence

///
infix operator ~~ : PartialApplicationPrecedence

///
infix operator ~> : ReverseApplicationPrecedence
