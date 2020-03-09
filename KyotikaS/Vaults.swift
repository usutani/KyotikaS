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
    
    // MARK: Properties
    var moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var treasureAnnotations: [TreasureAnnotation] = []
    var totalPassedCount = 0

    override init() {
        super.init()
        
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
    
}
