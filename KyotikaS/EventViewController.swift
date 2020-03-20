//
//  EventViewController.swift
//  KyotikaS
//
//  Created by Yasuhiro Usutani on 2020/03/20.
//  Copyright © 2020 toolstudio. All rights reserved.
//

import UIKit

protocol EventViewControllerDelegate : NSObjectProtocol {
    func eventViewControllerDone(_ vc: EventViewController)
}

class EventViewController: UIViewController {
    
    weak var delegate: EventViewControllerDelegate?
    var progress: Progress? = nil
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var helpLabel: UILabel!
    var imageView: UIImageView? = nil
    var stage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if progress == nil  {
            return
        }
        if progress!.isJustComplete {
            showGoalMessage()
        }
        else {
            showRainbow()
            showMessage()
            showHelp()
        }
    }
    
    fileprivate func showGoalMessage() {
        textView.text = "これで現在、登録されているスポットはすべて訪ね終わりました。京都チカチカツアーのご利用、誠にありがとうございました。\nでも、二人の旅は始まったばかりだ！"
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
        if progress!.isWaitingForNero == false {
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
        if progress == nil {
            dismiss(animated: true, completion: nil)
            return
        }
        if progress?.isCompleted == false {
            if progress?.isTogetherWithNero ?? false {
                switch stage {
                case 0:
                    stage += 1
                    textView.text = "そんな、まさか、でも\n間違いない…\n懐かしいみすぼらしいチョッキの小僧。\n\n寝露、寝露、寝露ォオオオ"
                    return
                case 1:
                    stage += 1
                    textView.text = "「破闘羅主ーーー」\n「アォオオオオオーーーン」\nもう大丈夫だー。心配ない寝露、これからはいつでも一緒だああ。"
                    return
                case 2:
                    stage += 1
                    textView.text = "どこ行ってたんだよぉ、勝手にいなくなってえええ。どんだけ心配かけさせたら気が済むんだこの駄犬があぁああ。」\n\nええええええええええ\n「ワキャン、キャン、キャィイイン」\n\n寝露が破闘羅主のお尻を叩く。\n「いっつも迷惑ばっかかけてええ」\n叩きながらもそれでも寝露は嬉しそうだ。\n破闘羅主も笑っている。お日様も笑ってるぅ、る〜るる、るるっる〜♩\nとにかく二人は再会できた。さあ、これからは二人で京都見学だ。\n\nレッツゴー京都！"
                    return
                default:
                    textView.text = ""
                }
            }
        }
        delegate?.eventViewControllerDone(self)
        dismiss(animated: true, completion: nil)
    }
}
