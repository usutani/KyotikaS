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

extension Notification.Name {
    static let hitTreasureNotification = Notification.Name("hitTreasureNotification")
}

class ViewController: UIViewController, MKMapViewDelegate, QuizTableViewControllerDelegate, VaultTabBarControllerDelegate {
    
    // MARK: Constants
    static let LOC_COORD_JR_KYOTO_STATION = CLLocationCoordinate2D(latitude: 34.985, longitude: 135.758)
    static let REGION_KYOTO = MKCoordinateRegion(center: LOC_COORD_JR_KYOTO_STATION, latitudinalMeters: 15000.0, longitudinalMeters: 15000.0)
    
    // MARK: Properties
    @IBOutlet weak var mapView: MKMapView!
    var viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var vaults: Vaults! = nil
    var treasureHunterAnnotation: TreasureHunterAnnotation?
    var treasurehunterAnnotationView: TreasureHunterAnnotationView?
    var targets: [TreasureAnnotation] = []
    var stopTargetModeButton: UIView? = nil
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(type(of: self).notified(notification:)), name: .hitTreasureNotification, object: nil)
    }
    
    @objc private func notified(notification: Notification) {
        if let ta = notification.object as? TreasureAnnotation {
            hitTreasureAnnotation(ta)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vaults = Vaults()
        vaults.makeArea(region: ViewController.REGION_KYOTO)
        
        // ハンター追加
        treasureHunterAnnotation = TreasureHunterAnnotation()
        treasureHunterAnnotation?.coordinate = ViewController.LOC_COORD_JR_KYOTO_STATION
        mapView.addAnnotation(treasureHunterAnnotation!)
        
        // JR京都駅を中心に地図を表示する。アニメーション抜き。
        mapView.region = ViewController.REGION_KYOTO
    }
    
    //MARK: MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//        mapView.addAnnotations(vaults.treasureAnnotations)
        
        // ハンター
        if treasureHunterAnnotation == nil {
            return
        }
        let gi = Vaults.gropuIndexForRegion(mapView.region)
        treasurehunterAnnotationView?.showRadar = (gi <= 0)
        let destinationLocation = mapView.centerCoordinate
        UIView.animate(withDuration: 0.2, animations: {
            self.treasureHunterAnnotation!.coordinate = destinationLocation
        }, completion: nil)
        
        let array = mapView.annotations
        let set = NSMutableSet(array: array)
        let result = vaults.treasureAnnotationsInRegion(region: mapView.region, hunter: treasureHunterAnnotation!.coordinate)
        let treasureAnnotations = result.treasureAnnotations
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
        
        if let hitAnnotation = result.hitAnnotation {
            hitAnnotation.notificationHitIfNeed()
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
                hitTreasureAnnotation(ta)
            }
        }
        if view is TreasureHunterAnnotationView {
            hitTreasureHunterAnnotation()
        }
        // 選択を解除
        for annotaion in mapView.selectedAnnotations {
            mapView.deselectAnnotation(annotaion, animated: false)
        }
    }
    
    func hitTreasureAnnotation(_ ta: TreasureAnnotation) {
        if presentedViewController != nil {
            return
        }
        
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
    
    func hitTreasureHunterAnnotation() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "VaultTabBarController") as? VaultTabBarController {
            vc.vaultTabBarControllerDelegate = self
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
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
                if let v = self.mapView.view(for: treasureAnnotation) as? TreasureAnnotationView {
                    v.startAnimation()
                }
            }
        }
        if let v = mapView.view(for: treasureAnnotation) as? TreasureAnnotationView {
            v.startAnimation()
        }
        
        os_log("Landmark name: %@, Correct: %d, Selected: %d", log: OSLog.default, type: .info, treasureAnnotation.landmark.name!, correct, view.selectedIndex)
    }
    
    // MARK: VaultTabBarControllerDelegate
    
    func showRelatedTargetLocations(_ ta: TreasureAnnotation) {
        stopTargetMode()
        startTargetMode(title: ta.passed ? ta.landmark.name : "?")
        
        vaults.treasureAnnotations.forEach { $0.target = false }
        ta.target = true
        targets = [ta]
        
        if let tav = mapView.view(for: ta) as? TreasureAnnotationView {
            tav.startAnimation()
        }
        showAllTarget(targets)
    }
    
    func showTargetLocations(tagName: String, treasureAnnotation: [TreasureAnnotation]) {
        stopTargetMode()
        if tagName == "" {
            return
        }
        if treasureAnnotation.count < 1 {
            return
        }
        startTargetMode(title: tagName)
        
        vaults.treasureAnnotations.forEach { $0.target = false }
        targets = treasureAnnotation
        
        for ta in targets {
            ta.target = true
            if let tav = mapView.view(for: ta) as? TreasureAnnotationView {
                tav.startAnimation()
            }
        }
        showAllTarget(targets)
    }
    
    fileprivate func startTargetMode(title: String?) {
        let topBarOffset: CGFloat = 40
        
        var frame = view.bounds
        frame.size.height = 44 + topBarOffset
        stopTargetModeButton = UIView(frame: frame)
        stopTargetModeButton?.backgroundColor = UIColor(hue: 0.6, saturation: 1, brightness: 0.2, alpha: 0.8)
        let tgr = UITapGestureRecognizer(target: self, action: #selector(type(of: self).stopTargetMode))
        stopTargetModeButton?.addGestureRecognizer(tgr)
        view.addSubview(stopTargetModeButton!)
        
        frame = stopTargetModeButton!.bounds
        frame.origin.y += 4
        frame.origin.y += topBarOffset
        frame.size.height = 20
        let titleLabel = UILabel(frame: frame)
        stopTargetModeButton?.addSubview(titleLabel)
        titleLabel.backgroundColor = .clear
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 14)
        titleLabel.textColor = .white
        titleLabel.text = "スポットモード（\(title ?? "")）"
        
        frame.origin.y += frame.size.height
        frame.size.height = 16
        let subtitleLabel = UILabel(frame: frame)
        stopTargetModeButton?.addSubview(subtitleLabel)
        subtitleLabel.backgroundColor = .clear
        subtitleLabel.text = "ここをタップすると通常モードに戻ります"
        subtitleLabel.textAlignment = .center
        subtitleLabel.font = .systemFont(ofSize: 12)
        subtitleLabel.textColor = .white
    }
    
    @objc private func stopTargetMode() {
        disableAllTargetLocations()
        stopTargetModeButton?.removeFromSuperview()
        stopTargetModeButton = nil;
    }
    
    fileprivate func disableAllTargetLocations() {
        for ta in targets {
            ta.target = false
            if let tav = mapView.view(for: ta) as? TreasureAnnotationView {
                tav.startAnimation()
            }
        }
    }
    
    fileprivate func showAllTarget(_ targets: [TreasureAnnotation]) {
        if targets.count == 0 {
            return
        }
        // 必要な領域を決める
        var curtRegion = mapView.region
        // 地図中心が京都チカチカのエリア外なら修正
        let hr = Region(ViewController.REGION_KYOTO)
        if !hr.coordinateInRegion(curtRegion.center) {
            curtRegion = ViewController.REGION_KYOTO
        }
        // 現在地を中心に、ターゲットに合わせて範囲を広げる。
        let startDelta: CLLocationDegrees = 0.001
        if curtRegion.span.latitudeDelta > startDelta {
            curtRegion.span.latitudeDelta = startDelta
        }
        if curtRegion.span.longitudeDelta > startDelta {
            curtRegion.span.longitudeDelta = startDelta
        }
        
        let coordinate = curtRegion.center
        var minlatitude = coordinate.latitude - curtRegion.span.latitudeDelta / 2
        var maxlatitude = minlatitude + curtRegion.span.latitudeDelta / 2
        var minlongitude = coordinate.longitude - curtRegion.span.longitudeDelta / 2
        var maxlongitude = minlongitude + curtRegion.span.longitudeDelta / 2
        for ta in targets {
            let coordinate = ta.coordinate
            if minlatitude > coordinate.latitude {
                minlatitude = coordinate.latitude
            }
            else if maxlatitude < coordinate.latitude {
                maxlatitude = coordinate.latitude
            }
            if minlongitude > coordinate.longitude {
                minlongitude = coordinate.longitude
            }
            else if maxlongitude < coordinate.longitude {
                maxlongitude = coordinate.longitude
            }
        }
        // 設定する領域
        let span = MKCoordinateSpan(latitudeDelta: maxlatitude - minlatitude, longitudeDelta: maxlongitude - minlongitude)
        let center = CLLocationCoordinate2D(latitude: minlatitude + (span.latitudeDelta / 2), longitude: minlongitude + (span.longitudeDelta / 2))
        var tmpRgn = MKCoordinateRegion(center: center, span: span)
        // 領域がギリギリだとマークが切れてしまうので、4インチも考慮して大きめにする
        let expandCoefficient = 1.3
        tmpRgn.span.longitudeDelta *= expandCoefficient
        tmpRgn.span.latitudeDelta *= expandCoefficient
        
        // モーダル画面が閉じてから移動する。
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if self.isSameRgn(tmpRgn) {
                self.mapView(self.mapView, regionDidChangeAnimated: false)
            }
            else {
                self.mapView.setRegion(tmpRgn, animated: true)
            }
        }
    }
    
    fileprivate func isSameRgn(_ region: MKCoordinateRegion) -> Bool {
        let krgn = mapView.regionThatFits(region)
        let mrgn = mapView.region
        
        if fabs(krgn.center.latitude - mrgn.center.latitude) > 0.0001 {
            return false
        }
        if fabs(krgn.center.longitude - mrgn.center.longitude) > 0.0001 {
            return false
        }
        if fabs(krgn.span.latitudeDelta - mrgn.span.latitudeDelta) > 0.0001 {
            return false
        }
        if fabs(krgn.span.longitudeDelta - mrgn.span.longitudeDelta) > 0.0001 {
            return false
        }
        return true
    }
    
    func hideTargetLocations() {
        stopTargetMode()
    }
    
    // MARK: VaultTabBarControllerDelegate
    
    func treasureAnnotations() -> [TreasureAnnotation] {
        return vaults.treasureAnnotations
    }
    
    func allPassedTags() -> [Tag] {
        return vaults.allPassedTags()
    }
    
    func treasureAnnotationsForTag(tag: Tag) -> [TreasureAnnotation] {
        return vaults.treasureAnnotationsForTag(tag: tag)
    }
}
