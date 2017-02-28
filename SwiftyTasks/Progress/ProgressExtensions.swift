//
//  File.swift
//  SwiftyTasks
//
//  Created by Victor Pavlychko on 2/28/17.
//  Copyright © 2017 address.wtf. All rights reserved.
//

import Foundation

fileprivate extension ProgressUserInfoKey {
    fileprivate static let labelKey = ProgressUserInfoKey(rawValue: "SwiftyTasks.ProgressUserInfoKey.labelKey")
}

public extension Progress {
    
    public convenience init(discreteUnitCount: Int64, label: String? = nil) {
        self.init(parent: nil)
        totalUnitCount = discreteUnitCount
        setUserInfoObject(label, forKey: .labelKey)
    }
    
    public var label: String? {
        get { return userInfo[.labelKey] as? String }
        set { setUserInfoObject(newValue, forKey: .labelKey) }
    }
    
    public func addComponent(progress componentProgress: Progress, unitCount: Int64? = nil) {
        let parentUnitCount = unitCount ?? componentProgress.totalUnitCount
        let progressProxy = ProgressProxy(componentProgress)
        totalUnitCount += parentUnitCount
        addChild(progressProxy, withPendingUnitCount: parentUnitCount)
    }
    
    public func complete() {
        if totalUnitCount > 0 {
            completedUnitCount = totalUnitCount
        } else {
            totalUnitCount = 1
            completedUnitCount = 1
        }
    }
}
