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

class ViewController: UIViewController, MKMapViewDelegate, QuizTableViewControllerDelegate {
    
    // MARK: Constants
    static let LOC_COORD_JR_KYOTO_STATION = CLLocationCoordinate2D(latitude: 34.985, longitude: 135.758)
    static let REGION_KYOTO = MKCoordinateRegion(center: LOC_COORD_JR_KYOTO_STATION, latitudinalMeters: 15000.0, longitudinalMeters: 15000.0)
    
    // MARK: Properties
    @IBOutlet weak var mapView: MKMapView!
    var viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var vaults: Vaults! = nil
    var treasureHunterAnnotation: TreasureHunterAnnotation! = nil
    var treasurehunterAnnotationView: TreasureHunterAnnotationView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vaults = Vaults()
        vaults.makeArea(region: ViewController.REGION_KYOTO)
        
        // ハンター追加
        treasureHunterAnnotation = TreasureHunterAnnotation()
        treasureHunterAnnotation.coordinate = ViewController.LOC_COORD_JR_KYOTO_STATION
        mapView.addAnnotation(treasureHunterAnnotation)
        
        // JR京都駅を中心に地図を表示する。アニメーション抜き。
        mapView.region = ViewController.REGION_KYOTO
    }
    
    //MARK: MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//        mapView.addAnnotations(vaults.treasureAnnotations)
        
        // ハンター
        let gi = Vaults.gropuIndexForRegion(mapView.region)
        treasurehunterAnnotationView.showRadar = (gi <= 0)
        let destinationLocation = mapView.centerCoordinate
        UIView.animate(withDuration: 0.2, animations: {
            self.treasureHunterAnnotation.coordinate = destinationLocation
        }, completion: nil)
        
        let array = mapView.annotations
        let set = NSMutableSet(array: array)
        let treasureAnnotations = vaults.treasureAnnotationsInRegion(region: mapView.region, hunter: treasureHunterAnnotation.coordinate)
        set.minus(treasureAnnotations as! Set<AnyHashable>)
        
        if let tha = treasureHunterAnnotation {
            set.remove(tha)
        }
        if set.count > 0 {
            mapView.removeAnnotations(set.allObjects as! [MKAnnotation])
        }
        treasureAnnotations.minus(NSSet(array: array) as! Set<AnyHashable>)
        
        if treasureAnnotations.count > 0 {
            mapView.addAnnotations(treasureAnnotations.allObjects as! [MKAnnotation])
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        switch annotation {
        case is TreasureAnnotation:
            let reuseId = "TreasureAnnotation"
            var av = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
            if av == nil {
                av = TreasureAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            }
            av?.annotation = annotation
            (av as! TreasureAnnotationView).startAnimation()
            return av
        case is AreaAnnotation:
            let reuseId = "AreaAnnotation"
            var av = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
            if av == nil {
                av = AreaAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            }
            av?.annotation = annotation
            (av as! AreaAnnotationView).startAnimation()
            return av
        case is TreasureHunterAnnotation:
            let reuseId = "TreasureHunterAnnotation"
            var av = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
            if av == nil {
                av = TreasureHunterAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            }
            av?.annotation = annotation
            if let thav = av as? TreasureHunterAnnotationView {
                thav.standbyNero = false
                treasurehunterAnnotationView = thav
            }
            return av
        default:
            return nil
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let tav = view as? TreasureAnnotationView {
            if let ta = tav.annotation as? TreasureAnnotation {
                if ta.passed {
                    os_log("TreasureAnnotation is passed. Name: %@", log: OSLog.default, type: .info, ta.landmark.name ?? "N/A")
                    return
                }
                if ta.locking {
                    os_log("TreasureAnnotation is locking. Name: %@", log: OSLog.default, type: .info, ta.landmark.name ?? "N/A")
                    return
                }
                // クイズを表示する。
                if let vc = storyboard?.instantiateViewController(withIdentifier: "QuizTableViewController") as? QuizTableViewController {
                    vc.question = ta.landmark.question ?? ""
                    vc.answers.append(ta.landmark.answer1 ?? "")
                    vc.answers.append(ta.landmark.answer2 ?? "")
                    vc.answers.append(ta.landmark.answer3 ?? "")
                    vc.userRef = ta
                    vc.modalPresentationStyle = .fullScreen
                    vc.delegate = self
                    present(vc, animated: true, completion: nil)
                }
            }
        }
        // 選択を解除
        for annotaion in mapView.selectedAnnotations {
            mapView.deselectAnnotation(annotaion, animated: false)
        }
    }
    
    //MARK: QuizTableViewControllerDelegate
    
    func quizTableViewControllerAnswer(_ view: QuizTableViewController) {
        guard let treasureAnnotation = view.userRef else {
            os_log("view.userRef is not setted.", log: OSLog.default, type: .error)
            return
        }
        
        treasureAnnotation.lastAtackDate = Date()
        
        let correct = (treasureAnnotation.landmark.correct?.intValue ?? 0) - 1
        if (view.selectedIndex == correct) {
            vaults.setPassedAnnotation(treasureAnnotation)
        }
        else {
            DispatchQueue.main.asyncAfter(deadline: .now() + TreasureAnnotation.PENALTY_DURATION + 0.2) {
                let v = self.mapView.view(for: treasureAnnotation) as! TreasureAnnotationView
                v.startAnimation()
            }
        }
        let v = mapView.view(for: treasureAnnotation) as! TreasureAnnotationView
        v.startAnimation()
        
        os_log("Landmark name: %@, Correct: %d, Selected: %d", log: OSLog.default, type: .info, treasureAnnotation.landmark.name!, correct, view.selectedIndex)
    }
}
