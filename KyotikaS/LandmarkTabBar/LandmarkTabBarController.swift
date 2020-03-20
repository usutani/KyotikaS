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
    
    weak var keywordTableViewControllerDelegate: KeywordTableViewControllerDelegate?
    var keywordTableViewController: KeywordTableViewController?
    var selectedTa: TreasureAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let nc = viewControllers?[0] as? UINavigationController {
            let landmarkInfoViewController = nc.viewControllers[0] as? LandmarkInfoViewController
            landmarkInfoViewController?.landmarkName = landmarkNameForLandmarkTabBar
            landmarkInfoViewController?.landmarkURL = URLForLandmarkTabBar
        }
        if let nc = viewControllers?[1] as? UINavigationController {
            keywordTableViewController = nc.viewControllers[0] as? KeywordTableViewController
            keywordTableViewController?.keywordTableViewControllerDelegate = keywordTableViewControllerDelegate
            if let tags = selectedTa?.landmark.tags?.allObjects {
                keywordTableViewController?.tags = tags as! [Tag]
            }
        }
    }
}
