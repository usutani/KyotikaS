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
}
