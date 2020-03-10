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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        isOpaque = false
        initFrameSize()
        initBlinker()
        startAnimation()
    }
    
    private func initFrameSize() {
        frame.size.width = 48
        frame.size.height = 48
    }
    
    private func initBlinker() {
        if blinker != nil {
            blinker.removeFromSuperlayer()
        }
        blinker = CALayer()
        blinker.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        blinker.contents = UIImage(named: "Shines")?.cgImage
        blinker.contentsRect = animationRects()[0]
        
        layer.cornerRadius = frame.size.width / 2
        layer.addSublayer(blinker)
    }
    
    private func startAnimation() {
        let ka = CAKeyframeAnimation(keyPath: "contentsRect")
        ka.values = animationRectValues()
        ka.calculationMode = .discrete
        ka.duration = 1
        ka.repeatCount = Float.infinity
        ka.isRemovedOnCompletion = false
        blinker.add(ka, forKey: "blinker")
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
