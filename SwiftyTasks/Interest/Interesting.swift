//
//  Interesting.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 2/8/17.
//  Copyright © 2017 address.wtf. All rights reserved.
//

import Foundation

public protocol Interesting: class {
    var interest: Interest { get }
    func loseInterest()
}

fileprivate let _lock = NSLock()

fileprivate struct AssociatedKeys {
    fileprivate struct Interesting {
        fileprivate static var interest = "SwiftyTasks.Interesting.interest"
    }
}

fileprivate class WeakInterestBox {
    
    public weak var interest: Interest?
    
    public init(_ interest: Interest) {
        self.interest = interest
    }
}

public extension Interesting {
    
    public var interest: Interest {
        return _lock.sync {
            if let box = objc_getAssociatedObject(self, &AssociatedKeys.Interesting.interest) as? WeakInterestBox {
                guard let interest = box.interest else {
                    fatalError()
                }
                return interest
            }
            let interest = Interest(self)
            objc_setAssociatedObject(self, &AssociatedKeys.Interesting.interest, WeakInterestBox(interest), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return interest
        }
    }
}

extension Operation: Interesting {
    
    public func loseInterest() {
        cancel()
    }
}
