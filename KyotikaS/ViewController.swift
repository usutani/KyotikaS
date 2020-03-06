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

class ViewController: UIViewController {

    var viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var landmarks: [Landmark] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "Landmark")
        fr.sortDescriptors = [NSSortDescriptor(key: #keyPath(Landmark.hiragana), ascending: true)]
        do {
            landmarks = try viewContext.fetch(fr) as! [Landmark]
            os_log("Landmark is fetched. Count: %d", log: OSLog.default, type: .info, landmarks.count)
        } catch {
            os_log("Landmark is not fetched.", log: OSLog.default, type: .error)
        }
    }

}
