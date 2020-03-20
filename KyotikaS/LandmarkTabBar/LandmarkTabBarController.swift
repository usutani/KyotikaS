//
//  LandmarkTabBarController.swift
//  KyotikaS
//
//  Created by Yasuhiro Usutani on 2020/03/20.
//  Copyright © 2020 toolstudio. All rights reserved.
//

import UIKit

class LandmarkTabBarController: UITabBarController {
    
    // MARK: Properties
    var landmarkNameForLandmarkTabBar = ""
    var URLForLandmarkTabBar = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let nc = viewControllers?[0] as? UINavigationController {
            let landmarkInfoViewController = nc.viewControllers[0] as? LandmarkInfoViewController
            landmarkInfoViewController?.landmarkName = landmarkNameForLandmarkTabBar
            landmarkInfoViewController?.landmarkURL = URLForLandmarkTabBar
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
