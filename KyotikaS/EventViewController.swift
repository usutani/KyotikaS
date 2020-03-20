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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    @IBAction func tap(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}
