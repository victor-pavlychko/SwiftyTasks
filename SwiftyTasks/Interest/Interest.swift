//
//  Interest.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 2/5/17.
//  Copyright © 2017 address.wtf. All rights reserved.
//

import Foundation

public class Interest: Hashable, Equatable {

    private let _interesting: Interesting

    public init(_ interesting: Interesting) {
        _interesting = interesting
    }
    
    deinit {
        _interesting.loseInterest()
    }
    
    public var hashValue: Int {
        return ObjectIdentifier(self).hashValue
    }
    
    public static func ==(lhs: Interest, rhs: Interest) -> Bool {
        return lhs === rhs
    }
}
