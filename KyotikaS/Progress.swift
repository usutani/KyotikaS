//
//  Progress.swift
//  KyotikaS
//
//  Created by Yasuhiro Usutani on 2020/03/12.
//  Copyright © 2020 toolstudio. All rights reserved.
//

import UIKit
import os.log

class Progress: NSObject {
    
    var complete = 0.0
    var messageIndex: Int {
        get {
            var index = Int(complete * 10.0) / 2 - 1;
            if index < 0 {
                index = 0
            }
            if index >= 5 {
                index = 4
            }
            return index;
        }
    }
    
    func initWithUserDefaults() {
        complete = UserDefaults.standard.double(forKey: "complete")
        os_log("initWithUserDefaults. complete:%f", log: OSLog.default, type: .info, complete)
    }
    
    func updateAnnotations(amount: Int, totalPassedCount: Int) {
        if complete < 1.0 {
            let progress = Double(totalPassedCount) / Double(amount) * 4.0
            let times = Int(progress / 0.2 + 1)
            let value = 0.2 * Double(times)
            if value >= complete {
                complete = value
            }
        }
        else if (complete < 2.0) && (complete >= 1.0) {
            if totalPassedCount == amount {
                complete = 2.0
            }
        }
        os_log("updateAnnotations. complete:%f", log: OSLog.default, type: .info, complete)
    }
    
    func save() {
        UserDefaults.standard.set(complete, forKey: "complete")
    }
}
