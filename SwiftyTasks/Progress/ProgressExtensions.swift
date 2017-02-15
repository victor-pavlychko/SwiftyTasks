//
//  ProgressExtensions.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 2/15/17.
//  Copyright © 2017 address.wtf. All rights reserved.
//

import Foundation

fileprivate struct AssociatedKeys {
    fileprivate struct Progress {
        fileprivate static var _dependencies = "SwiftyTasks.Progress._dependencies"
        fileprivate static var _isPrincipal = "SwiftyTasks.Progress._isPrincipal"
    }
}

public extension Progress {
    
    /// <#Description#>
    private var _dependencies: NSMutableArray {
        if let dependencies = objc_getAssociatedObject(self, &AssociatedKeys.Progress._dependencies) as? NSMutableArray {
            return dependencies
        }
        let dependencies = NSMutableArray()
        objc_setAssociatedObject(self, &AssociatedKeys.Progress._dependencies, dependencies, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return dependencies
    }
    
    /// <#Description#>
    private var _isPrincipal: Bool {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.Progress._isPrincipal) as? Bool ?? false }
        set { objc_setAssociatedObject(self, &AssociatedKeys.Progress._isPrincipal, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    /// <#Description#>
    ///
    /// - Parameter dependency: <#dependency description#>
    public func addDependency(_ dependency: Progress) {
        sync {
            _dependencies.add(ProgressLink(parent: self, child: dependency))
        }
    }
    
    /// <#Description#>
    public func becomePrincipal() {
        sync {
            _isPrincipal = true
        }
    }

    public var isPrincipal: Bool {
        return _isPrincipal
    }
}

public extension Progress {
    
    public static func connect(progressReporting lhs: Any, addDependency rhs: Any) {
        if let lhs = lhs as? ProgressReporting, let rhs = rhs as? ProgressReporting {
            lhs.progress.addDependency(rhs.progress)
        }
    }
}
