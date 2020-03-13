//
//  Vaults.swift
//  KyotikaS
//
//  Created by Yasuhiro Usutani on 2020/03/09.
//  Copyright © 2020 toolstudio. All rights reserved.
//

import UIKit
import CoreData
import MapKit
import os.log

class Vaults: NSObject {
    
    // MARK: Constants
    static let KMVaultsAreaThresholdSpan: CLLocationDistance = 2000
    
    // MARK: Properties
    var moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var treasureAnnotations: [TreasureAnnotation] = []
    
    var totalPassedCount = 0
    var progress = Progress()
    
    var groupAnnotations = [NSDictionary](repeating: NSDictionary(), count: 3)
    
    override init() {
        super.init()
        
        progress.initWithUserDefaults()
        
        for l in landmarks() {
            let ta = TreasureAnnotation()
            if (l.passed!.boolValue) {
                totalPassedCount += 1
            }
            ta.landmark = l
            ta.title = l.name
            ta.coordinate = CLLocationCoordinate2D(latitude: l.latitude!.doubleValue, longitude: l.longitude!.doubleValue)
            treasureAnnotations.append(ta)
        }
    }
    
    func landmarks() -> [Landmark] {
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "Landmark")
        fr.sortDescriptors = [NSSortDescriptor(key: #keyPath(Landmark.hiragana), ascending: true)]
        do {
            let landmarks = try moc.fetch(fr) as! [Landmark]
            os_log("Landmark is fetched. Count: %d", log: OSLog.default, type: .info, landmarks.count)
            return landmarks
        } catch {
            os_log("Landmark is not fetched.", log: OSLog.default, type: .error)
            return []
        }
    }
    
    func setPassedAnnotation(_ ta: TreasureAnnotation) {
        if !ta.passed {
            totalPassedCount += 1
            ta.passed = true
        }
        handleProgress()
    }
    
    private func handleProgress() {
        progress.updateAnnotations(amount: treasureAnnotations.count, totalPassedCount: totalPassedCount)
        progress.save()
    }
    
    func makeArea(region: MKCoordinateRegion) {
        groupAnnotations[0] = makeGroupAnnotations(region: region, latitudeDivCount:20, longitudeDivCount:24)
        groupAnnotations[1] = makeGroupAnnotations(region: region, latitudeDivCount:10, longitudeDivCount:12)
        groupAnnotations[2] = makeGroupAnnotations(region: region, latitudeDivCount:5, longitudeDivCount:6)
    }
    
    private func makeGroupAnnotations(region: MKCoordinateRegion, latitudeDivCount: Int, longitudeDivCount: Int) -> NSDictionary {
        let groupAnnotations = NSMutableDictionary(capacity: latitudeDivCount * longitudeDivCount)
        
        let top = region.center.latitude - (region.span.latitudeDelta / 2)
        let latitudeDelta = region.span.latitudeDelta / Double(latitudeDivCount)
        
        let left = region.center.longitude - (region.span.longitudeDelta / 2)
        let longitudeDelta = region.span.longitudeDelta / Double(longitudeDivCount)
        
        for a in treasureAnnotations {
            var v = a.coordinate.latitude - top;
            v /= latitudeDelta;
            if v < 0.0 {
                continue
            }
            if v >= Double(latitudeDivCount) {
                continue
            }
            
            var h = a.coordinate.longitude - left
            h /= longitudeDelta
            if h < 0.0 {
                continue
            }
            if h >= Double(longitudeDivCount) {
                continue
            }
            
            let key = String(format: "%dx%d", Int(h), Int(v))
            if groupAnnotations.value(forKey: key) == nil {
                let pin = AreaAnnotation()
                let latitude = v * latitudeDelta
                let longitude = h * longitudeDelta
                pin.coordinate = CLLocationCoordinate2D(
                    latitude: latitude + top + (latitudeDelta / 2.0),
                    longitude: longitude + left + (longitudeDelta / 2.0))
                pin.title = nil
                groupAnnotations.setValue(pin, forKey: key)
            }
        }
        return groupAnnotations
    }
    
    // 指定された領域のTreasureAnnotationのセット
    func treasureAnnotationsInRegion(region: MKCoordinateRegion) -> NSMutableSet {
//        return NSSet(array: treasureAnnotations)
        
        // FIXME
        // 現時点ではピンアノテーションが表示されている。
        // お宝かゴゴゴかのダウンキャストが必要か？
        
        let set = NSMutableSet()
        let r = Region(region)
        
        let index = Vaults.gropuIndexForRegion(region)
        if index > 0 {
            let garray = groupAnnotations[index].allValues as! [MKPointAnnotation]
            for a in garray {
                if r.coordinateInRegion(a.coordinate) {
                    set.add(a)
                }
            }
            return set
        }
        
        for a in treasureAnnotations {
            set.add(a)
        }
        
        return set
    }
    
    private class func gropuIndexForRegion(_ region: MKCoordinateRegion) -> Int {
        var index = -1
        var thresholdSpan = KMVaultsAreaThresholdSpan
        
        while index < 2 {
            let threshold = MKCoordinateRegion(center: region.center, latitudinalMeters: thresholdSpan, longitudinalMeters: thresholdSpan)
            if region.span.longitudeDelta < threshold.span.longitudeDelta {
                break
            }
            index += 1
            thresholdSpan *= 2
        }
        return index;
    }
}

struct Region {
    var minlatitude: CLLocationDegrees
    var maxlatitude: CLLocationDegrees
    var minlongitude: CLLocationDegrees
    var maxlongitude: CLLocationDegrees
    
    init (_ region: MKCoordinateRegion) {
        minlatitude = region.center.latitude - region.span.latitudeDelta
        maxlatitude = region.center.latitude + region.span.latitudeDelta
        minlongitude = region.center.longitude - region.span.longitudeDelta
        maxlongitude = region.center.longitude + region.span.longitudeDelta
    }
    
    func coordinateInRegion(_ coordinate: CLLocationCoordinate2D) -> Bool {
        if coordinate.longitude < minlongitude {
            return false
        }
        if coordinate.longitude > maxlongitude {
            return false
        }
        if coordinate.latitude < minlatitude {
            return false
        }
        if coordinate.latitude > maxlatitude {
            return false
        }
        return true
    }
}
