//
//  AreaAnnotationView.swift
//  KyotikaS
//
//  Created by Yasuhiro Usutani on 2020/03/13.
//  Copyright © 2020 toolstudio. All rights reserved.
//

import UIKit
import MapKit

class AreaAnnotationView: MKAnnotationView {
    
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
        frame.size.width = 24
        frame.size.height = 24
    }
    
    private func initBlinker() {
        if blinker != nil {
            blinker.removeFromSuperlayer()
        }
        blinker = CALayer()
        blinker.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        blinker.contents = UIImage(named: "Ggg")?.cgImage
        blinker.contentsRect = animationRects()[0]

        layer.cornerRadius = frame.size.width / 2
        layer.addSublayer(blinker)
    }
    
    func startAnimation() {
        let ka = CAKeyframeAnimation(keyPath: "contentsRect")
        ka.values = animationRectValues()
        ka.calculationMode = .discrete
        ka.duration = 0.3
        ka.repeatCount = Float.infinity
        ka.isRemovedOnCompletion = false
        blinker.add(ka, forKey: "blinker")
    }
    
    private func animationRectValues() -> [NSValue] {
        return animationRects().map { NSValue(cgRect: $0) }
    }
    
    private func animationRects() -> [CGRect] {
        return [
            CGRect(x: 0.0, y: 0, width: 0.5, height: 1),
            CGRect(x: 0.5, y: 0, width: 0.5, height: 1),
        ]
    }
}
