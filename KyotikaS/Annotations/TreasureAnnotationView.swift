//
//  TreasureAnnotationView.swift
//  KyotikaS
//
//  Created by Yasuhiro Usutani on 2020/03/10.
//  Copyright © 2020 toolstudio. All rights reserved.
//

import UIKit
import MapKit

class TreasureAnnotationView: MKAnnotationView {
    
    var blinker: CALayer!
    var locker: CALayer!
    var nameLabel: UILabel? = nil

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        isOpaque = false
        initFrameSize()
        initLocker()
        startAnimation()
    }
    
    private func initFrameSize() {
        frame.size.width = 48
        frame.size.height = 48
    }
    
    private func initLocker() {
        if locker != nil {
            locker.removeFromSuperlayer()
        }
        locker = CALayer()
        locker.contentsScale = UIScreen.main.scale
        locker.frame = layer.bounds
        locker.contents = UIImage(named: "Lock")?.cgImage
        locker.contentsGravity = .center
    }
    
    func startAnimation() {
        image = nil
        nameLabel?.removeFromSuperview()
        nameLabel = nil
        
        let ta = self.annotation as! TreasureAnnotation
        if ta.passed && !ta.target {
            if blinker != nil {
                blinker.removeFromSuperlayer()
                blinker = nil
            }
            if locker != nil {
                locker.removeFromSuperlayer()
            }
            image = UIImage(named: "Landmark")
            showNameLabel(treasureAnnotation: ta)
            return
        }
        
        if blinker == nil {
            blinker = CALayer()
            blinker.frame = bounds
            blinker.contentsScale = UIScreen.main.scale
            layer.addSublayer(blinker)
        }
        if ta.target {
            if ta.passed {
                blinker.contents = UIImage(named: "LandmarkTargetPassed")?.cgImage
                showNameLabel(treasureAnnotation: ta)
            }
            else {
                blinker.contents = UIImage(named: "LandmarkTarget")?.cgImage
            }
            blinker.contentsRect = CGRect(x: 0, y: 0, width: 1, height: 1)
            let ba = CABasicAnimation()
            ba.fromValue = NSValue(caTransform3D:CATransform3DMakeScale(0.8, 0.8, 1.0))
            ba.toValue =  NSValue(caTransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0))
            ba.duration = 1
            ba.isRemovedOnCompletion = false
            ba.autoreverses = true
            ba.repeatCount = Float.infinity
            blinker.removeAnimation(forKey: "shine")
            blinker.add(ba, forKey: "transform")
        }
        else {
            blinker.contents = UIImage(named: "Shines")?.cgImage
            blinker.contentsRect = animationRects()[0]
            let ka = CAKeyframeAnimation(keyPath: "contentsRect")
            ka.values = animationRectValues()
            ka.calculationMode = .discrete
            ka.duration = 1
            ka.repeatCount = Float.infinity
            ka.isRemovedOnCompletion = false
            blinker.removeAnimation(forKey: "transform")
            blinker.add(ka, forKey: "shine")
        }
        
        if ta.locking {
            layer.addSublayer(locker)
        }
        else {
            locker?.removeFromSuperlayer()
        }
    }
    
    fileprivate func showNameLabel(treasureAnnotation ta: TreasureAnnotation) {
        nameLabel = UILabel(frame: bounds)
        nameLabel?.text = ta.landmark.name
        nameLabel?.textAlignment = .center
        nameLabel?.font = UIFont.systemFont(ofSize: 12.0)
        nameLabel?.textColor = .white
        nameLabel?.backgroundColor = .darkGray
        nameLabel?.layer.cornerRadius = 3
        nameLabel?.clipsToBounds = true
        nameLabel?.sizeToFit()
        var labelFrame = (nameLabel?.frame.insetBy(dx: -3, dy: -1))!
        labelFrame.origin.x -= (labelFrame.size.width / 2 - bounds.width / 2)
        labelFrame.origin.y += bounds.height
        nameLabel?.frame = labelFrame
        addSubview(nameLabel!)
    }
    
    private func animationRectValues() -> [NSValue] {
        return animationRects().map { NSValue(cgRect: $0) }
    }
    
    private func animationRects() -> [CGRect] {
        return [
            CGRect(x: 0.0, y: 0, width: 0.2, height: 1),
            CGRect(x: 0.2, y: 0, width: 0.2, height: 1),
            CGRect(x: 0.4, y: 0, width: 0.2, height: 1),
            CGRect(x: 0.6, y: 0, width: 0.2, height: 1),
            CGRect(x: 0.8, y: 0, width: 0.2, height: 1),
        ]
    }
}
