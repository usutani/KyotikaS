//
//  EventViewController.swift
//  KyotikaS
//
//  Created by Yasuhiro Usutani on 2020/03/20.
//  Copyright © 2020 toolstudio. All rights reserved.
//

import UIKit

class EventViewController: UIViewController {
    
    var progress: Progress? = nil
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var helpLabel: UILabel!
    var imageView: UIImageView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showRainbow()
        showMessage()
        showHelp()
    }
    
    fileprivate func showMessage() {
        if progress == nil {
            return
        }
        let messages = [
            "な、なんだか思い出せそうだワン",
            "あ、あれは確か…、\nそうか、ここが…",
            "お、思いだっ、ぎゃわん、頭が…\n急に頭がぁああ\nやっぱり思い出せないワォオオオン",
            "こ、ここは",
            "お、思い出したワン！\nここが、あの…\n\n「パ、破闘羅主」",
        ]
        textView.text = messages[progress!.messageIndex]
    }
    
    fileprivate func showHelp() {
        if helpLabel == nil {
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.helpLabel.isHidden = false
        }
    }
    
    fileprivate func showRainbow() {
        if progress == nil {
            return
        }
        var frame = view.bounds
        frame.origin.y += frame.size.height - frame.size.width;
        frame.size.height = frame.size.width;
        imageView = UIImageView(frame: frame)
        view.insertSubview(imageView!, belowSubview: textView)
        imageView!.layer.anchorPoint = CGPoint(x: 1.0, y: 1.0)
        imageView!.layer.frame = frame
        
        imageView!.image = UIImage(named: "Rainbow")
        
        //TODO
//        let animation = CAKeyframeAnimation(keyPath: "transform")
//        let a0: CGFloat = 0.1
//        let a1: CGFloat = CGFloat(progress!.complete)
//        animation.values = [
//            NSValue(caTransform3D:CATransform3DMakeScale(a0, a0, 1.0)),
//            NSValue(caTransform3D:CATransform3DMakeScale(a1, a1, 1.0)),
//        ]
//        animation.keyTimes = [0.0, 1.0]
//
//        let alphaanimation = CAKeyframeAnimation(keyPath: "opacity")
//        alphaanimation.values = [
//            a0,
//            a1,
//        ]
//        alphaanimation.keyTimes = animation.keyTimes
//
//        let theGroup = CAAnimationGroup()
//        theGroup.animations = [
//            animation,
//            alphaanimation,
//        ]
//        theGroup.duration = 2
//        theGroup.repeatCount = Float.infinity
//        theGroup.autoreverses = true
//
//        imageView?.layer.add(theGroup, forKey: "puyopuyo")
    }
    
    @IBAction func tap(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}
