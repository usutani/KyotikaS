//
//  TreasureAnnotation.swift
//  KyotikaS
//
//  Created by Yasuhiro Usutani on 2020/03/09.
//  Copyright © 2020 toolstudio. All rights reserved.
//

import UIKit
import MapKit

class TreasureAnnotation: MKPointAnnotation {
    
    // MARK: Constants
    static let PENALTY_DURATION = 120.0
    
    // MARK: Properties
    var landmark: Landmark!
    var passed: Bool {
        get {
            return landmark.passed!.boolValue
        }
        set(newValue) {
            landmark.passed = newValue as NSNumber
        }
    }
    var lastAtackDate: Date? = nil
    var locking: Bool {
        if passed {
            return false
        }
        if lastAtackDate == nil {
            return false
        }
        let timeInterval = Date().timeIntervalSince(lastAtackDate!)
        if timeInterval < TreasureAnnotation.PENALTY_DURATION {
            return true
        }
        return false
    }
    var find: Bool {
        get {
            return landmark.found!.boolValue
        }
        set(newValue) {
            landmark.found = newValue as NSNumber
        }
    }
    var target: Bool = false
    
    func notificationHitIfNeed() {
        if !find {
            return
        }
        if locking {
            return
        }
        let center = NotificationCenter.default
        center.post(name: .hitTreasureNotification, object: self)
    }
}
