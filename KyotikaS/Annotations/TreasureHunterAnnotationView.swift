//
//  TreasureHunterAnnotationView.swift
//  ios_study_animated_mkannotation
//
//  Created by Yasuhiro Usutani on 2020/02/16.
//  Copyright © 2020 toolstudio. All rights reserved.
//

import UIKit
import MapKit

class TreasureHunterAnnotationView: MKAnnotationView, CAAnimationDelegate {
    var standbyNero = true {
        didSet {
            initWalker()
            startAnimation()
        }
    }
    var showRadar = false {
        didSet {
            if showRadar {
                if searching {  // 検索中なら表示しない
                    return
                }
                if radar?.superlayer != nil {
                    return
                }
                if radar == nil {
                    radar = CALayer()
                }
                radar.frame = self.bounds.insetBy(dx: -20, dy: -20);
                radar.contents = UIImage(named: "Radar")?.cgImage
                layer.insertSublayer(radar, below: walker)
                
                let radarAnimation = CAKeyframeAnimation(keyPath: "transform")
                radarAnimation.values = [
                    NSValue(caTransform3D:CATransform3DIdentity),
                    NSValue(caTransform3D:CATransform3DMakeRotation(3.14, 0, 0, 1)),
                    NSValue(caTransform3D:CATransform3DMakeRotation(3.14 * 2, 0, 0, 1)),
                ]
                radarAnimation.duration = 3
                radarAnimation.repeatCount = Float.infinity
                radarAnimation.isRemovedOnCompletion = false
                radar.add(radarAnimation, forKey: "radar")
            }
            else {
                radar?.removeFromSuperlayer()
            }
        }
    }
    var walker: CALayer!
    var radar: CALayer!
    
    var target: ViewController? = nil
    var searchAnimationView1: UIView? = nil
    var searchAnimationView2: UIView? = nil
    var searching: Bool = false
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        isOpaque = false
        initFrameSize()
    }
    
    func initFrameSize() {
        // フレームサイズを適切な値に設定する
        frame.size.width = 48
        frame.size.height = 48
    }
    
    func initWalker() {
        if walker != nil {
            walker.removeFromSuperlayer()
        }
        walker = CALayer()
        // contentsScale = [UIScreen mainScreen].scale は特に必要ない
        // contentsGravity = kCAGravityResizeなので
        walker.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        walker.contents = walkerImage()
        walker.contentsRect = aroundAnimationRects()[0]
        
        layer.cornerRadius = frame.size.width / 2
        layer.addSublayer(walker)
    }
    
    func walkerImage() -> CGImage? {
        let name = standbyNero ? "PatorashNero" : "Patorash"
        return UIImage(named: name)?.cgImage
    }
    
    func startAnimation() {
        // アニメーションの設定
        let walkAnimation = CAKeyframeAnimation(keyPath: "contentsRect")
        walkAnimation.values = aroundAnimationRectValues()
        walkAnimation.calculationMode = .discrete
        walkAnimation.duration = 1
        walkAnimation.repeatCount = Float.infinity
        walkAnimation.isRemovedOnCompletion = false
        walker.add(walkAnimation, forKey: "walk")
    }
    
    func aroundAnimationRectValues() -> [NSValue] {
        return aroundAnimationRects().map { NSValue(cgRect: $0) }
    }

    func aroundAnimationRects() -> [CGRect] {
        let quarter = 0.25
        if standbyNero {
            return [
                CGRect(x: 0, y: 0.00, width: 1, height: quarter),
                CGRect(x: 0, y: 0.25, width: 1, height: quarter),
                CGRect(x: 0, y: 0.50, width: 1, height: quarter),
                CGRect(x: 0, y: 0.75, width: 1, height: quarter),
            ]
        }
        else {
            return [
                CGRect(x: 0, y: 0.00, width: quarter, height: quarter),
                CGRect(x: 0, y: 0.25, width: quarter, height: quarter),
                CGRect(x: 0, y: 0.50, width: quarter, height: quarter),
                CGRect(x: 0, y: 0.75, width: quarter, height: quarter),
            ]
        }
    }
    
    // MARK: Search with GNSS
    
    func searchAnimationOnView(_ view: UIView, target: ViewController) {
        if searchAnimationView1 != nil {
            return
        }
        self.target = target
        searching = true
        showRadar = false
        
        let rv = UIImageView(image: UIImage(named: "Searcher"))
        rv.layer.anchorPoint = CGPoint(x: 0.0, y: 1.0)
        var frame = rv.frame
        var length = view.bounds.size.width
        if length < view.bounds.size.height {
            length = view.bounds.height
        }
        length /= 2
        let scale = (length * 1.0) / frame.size.width
        frame.size.width *= scale
        frame.size.height *= scale
        frame.origin.x = view.bounds.size.width / 2
        frame.origin.y = view.bounds.size.height / 2 - frame.size.height
        rv.frame = frame
        let searchAnimation = CAKeyframeAnimation(keyPath: "transform")
        searchAnimation.values = [
            NSValue(caTransform3D:CATransform3DIdentity),
            NSValue(caTransform3D:CATransform3DMakeRotation(3.14, 0, 0, 1)),
            NSValue(caTransform3D:CATransform3DMakeRotation(3.14 * 2, 0, 0, 1)),
        ]
        searchAnimation.duration = 2
        searchAnimationView1 = rv
        
        let ov = UIImageView(image: UIImage(named: "Ora"))
        ov.frame = CGRect(x: -100, y: view.bounds.size.height - 80, width: view.bounds.size.width, height: 80)
        let oa = CAKeyframeAnimation(keyPath: "transform")
        oa.values = [
            NSValue(caTransform3D: CATransform3DMakeTranslation(ov.frame.size.width, 0, 1)),
            NSValue(caTransform3D: CATransform3DIdentity),
        ]
        oa.duration = 2
        oa.delegate = self
        searchAnimationView2 = ov
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            view.addSubview(rv)
            rv.layer.add(searchAnimation, forKey: "Searcher")
            view.addSubview(ov)
            ov.layer.add(oa, forKey: "Ora")
        })
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        searching = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            self.showRadar = true
        })
        
        searchAnimationView1?.removeFromSuperview()
        searchAnimationView1 = nil
        searchAnimationView2?.removeFromSuperview()
        searchAnimationView2 = nil
        
        target?.searchFinished()
    }
}
