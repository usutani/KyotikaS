//
//  LocationManager.swift
//  KyotikaS
//
//  Created by Yasuhiro Usutani on 2020/03/23.
//  Copyright © 2020 toolstudio. All rights reserved.
//

import UIKit
import CoreLocation

class LocationManager: NSObject {
    
    var locationManager: CLLocationManager? = nil
    
    func start() {
        if locationManager == nil {
            locationManager = CLLocationManager()
        }
        locationManager?.requestWhenInUseAuthorization()
    }
}
