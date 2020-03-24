//
//  LocationManager.swift
//  KyotikaS
//
//  Created by Yasuhiro Usutani on 2020/03/23.
//  Copyright © 2020 toolstudio. All rights reserved.
//

import UIKit
import CoreLocation

protocol LocationManagerDelegate : NSObjectProtocol {
    func locationManagerUpdate(_ manager: LocationManager)
    func locationManagerDidFailWithError()
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager? = nil
    var delegate: LocationManagerDelegate? = nil
    var curtLocation: CLLocation? = nil
    
    func start() {
        if locationManager == nil {
            locationManager = CLLocationManager()
        }
        // スタート済み
        if locationManager?.delegate != nil {
            return
        }
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.distanceFilter = 10.0  // 10m以上の移動で通知
        locationManager?.startUpdatingLocation()
    }
    
    func stop() {
        if locationManager?.delegate == nil {
            return
        }
        locationManager?.stopUpdatingLocation()
        locationManager?.delegate = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.first
        // 負の値はあてにならない事を意味する
        if newLocation?.horizontalAccuracy ?? -1 < 0 {
            return
        }
        // 5秒以上時間が経っている：キャッシュデータ
        var locationAge = newLocation?.timestamp.timeIntervalSinceNow ?? 0
        locationAge = -locationAge
        if locationAge > 5.0 {
            return
        }
        if curtLocation != nil {
            let distance:Double = newLocation?.distance(from: curtLocation!) ?? 0
            let desiredAccuracy:Double = locationManager?.desiredAccuracy ?? 0
            if distance < desiredAccuracy {
                return
            }
        }
        curtLocation = newLocation?.copy() as? CLLocation
        delegate?.locationManagerUpdate(self)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate?.locationManagerDidFailWithError()
    }
}
