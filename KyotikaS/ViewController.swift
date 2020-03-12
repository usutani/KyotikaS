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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vaults = Vaults()
        
        // JR京都駅を中心に地図を表示する。アニメーション抜き。
        mapView.region = ViewController.REGION_KYOTO
    }
    
    //MARK: MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        // 現時点では全てのお宝を表示する。状態に応じた画像表示もなし。
        mapView.addAnnotations(vaults.treasureAnnotations)
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
            return av
        default:
            return nil
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let tav = view as? TreasureAnnotationView {
            print(tav.annotation?.coordinate ?? "")
            if let ta = tav.annotation as? TreasureAnnotation {
                print(ta.landmark.name ?? "")
                print(ta.landmark.question ?? "")
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
        let correct = (treasureAnnotation.landmark.correct?.intValue ?? 0) - 1
        if (view.selectedIndex == correct) {
            vaults.setPassedAnnotation(treasureAnnotation)
            let v = mapView.view(for: treasureAnnotation) as! TreasureAnnotationView
            v.startAnimation()
        }
    }
}
