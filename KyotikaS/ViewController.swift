//
//  ViewController.swift
//  KyotikaS
//
//  Created by Yasuhiro Usutani on 2020/03/06.
//  Copyright © 2020 toolstudio. All rights reserved.
//

import UIKit
import CoreData
import os.log
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: Constants
    static let LOC_COORD_JR_KYOTO_STATION = CLLocationCoordinate2D(latitude: 34.985, longitude: 135.758)
    static let REGION_KYOTO = MKCoordinateRegion(center: LOC_COORD_JR_KYOTO_STATION, latitudinalMeters: 15000.0, longitudinalMeters: 15000.0)
    
    // MARK: Properties
    @IBOutlet weak var mapView: MKMapView!
    var viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var landmarks: [Landmark] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "Landmark")
        fr.sortDescriptors = [NSSortDescriptor(key: #keyPath(Landmark.hiragana), ascending: true)]
        do {
            landmarks = try viewContext.fetch(fr) as! [Landmark]
            os_log("Landmark is fetched. Count: %d", log: OSLog.default, type: .info, landmarks.count)
        } catch {
            os_log("Landmark is not fetched.", log: OSLog.default, type: .error)
        }
        
        // JR京都駅を中心に地図を表示する。アニメーション抜き。
        mapView.region = ViewController.REGION_KYOTO
    }

}
