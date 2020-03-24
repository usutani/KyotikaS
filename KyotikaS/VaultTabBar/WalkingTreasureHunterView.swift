//
//  WalkingTreasureHunterView.swift
//  KyotikaS
//
//  Created by Yasuhiro Usutani on 2020/03/24.
//  Copyright © 2020 toolstudio. All rights reserved.
//

import UIKit

import UIKit

class WalkingTreasureHunterView: UIView {
    
    var walker: CALayer!
    var direction = 0
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        direction = tag
        startAnimation()
    }
    
    func startAnimation() {
        if walker == nil {
            walker = CALayer()
        }
        walker.frame = bounds
        walker.contents = UIImage(named: "Patorash")?.cgImage
        walker.contentsRect = animationRects()[0]

        layer.cornerRadius = frame.size.width / 2
        layer.addSublayer(walker)
        
        let walkAnimation = CAKeyframeAnimation(keyPath: "contentsRect")
        walkAnimation.values = animationRectValues()
        walkAnimation.calculationMode = .discrete
        walkAnimation.duration = 1
        walkAnimation.repeatCount = Float.infinity
        walkAnimation.isRemovedOnCompletion = false
        walker.add(walkAnimation, forKey: "walk")
    }
    
    func animationRectValues() -> [NSValue] {
        return animationRects().map { NSValue(cgRect: $0) }
    }
    
    func animationRects() -> [CGRect] {
        let quarter = 0.25
        let y = quarter * Double(direction)
        return [
            CGRect(x: 0.00, y: y, width: quarter, height: quarter),
            CGRect(x: 0.25, y: y, width: quarter, height: quarter),
            CGRect(x: 0.50, y: y, width: quarter, height: quarter),
            CGRect(x: 0.75, y: y, width: quarter, height: quarter),
        ]
    }
}
