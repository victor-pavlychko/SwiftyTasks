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

public extension ProgressUserInfoKey {

    public static let descriptionKey = ProgressUserInfoKey(rawValue: "SwiftyTasks.ProgressUserInfoKey.descriptionKey")
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
    public func addDependency(_ dependency: Progress, unitCount: Int64? = nil) {
        sync {
            _dependencies.add(ProgressLink(parent: self, child: dependency, unitCount: unitCount ?? dependency.totalUnitCount))
        }
    }
    
    /// <#Description#>
    public func becomePrincipal() {
        _isPrincipal = true
    }

    /// <#Description#>
    public var isPrincipal: Bool {
        return _isPrincipal
    }
    
    convenience init(discreteUnitCount: Int64, description: String? = nil) {
        self.init(parent: nil)
        totalUnitCount = discreteUnitCount
        setUserInfoObject(description, forKey: .descriptionKey)
    }
    
    public var progressDescription: String {
        return userInfo[.descriptionKey] as? String ?? "UNKNOWN"
    }

    public func compoundProgressDescription(_ indent: String = "") -> String {
        let address = Unmanaged.passUnretained(self).toOpaque()
        var result = "\(indent)<\(String(describing: type(of: self))): \(address), \(completedUnitCount)/\(totalUnitCount) (\(fractionCompleted)) - \(progressDescription)>"
        for dependency in _dependencies {
            if let dependency = dependency as? ProgressLink {
                result += "\n" + dependency._proxy.compoundProgressDescription(indent + "  ")
                result += "\n" + dependency._child.compoundProgressDescription(indent + "      ")
            }
        }
        return result
    }
}

internal extension Progress {
    
    internal func complete() {
        if totalUnitCount > 0 {
            completedUnitCount = totalUnitCount
        } else {
            totalUnitCount = 1
            completedUnitCount = 1
        }
    }
}
