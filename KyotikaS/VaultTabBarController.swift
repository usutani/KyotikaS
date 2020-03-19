//
//  VaultTabBarController.swift
//  KyotikaS
//
//  Created by Yasuhiro Usutani on 2020/03/19.
//  Copyright © 2020 toolstudio. All rights reserved.
//

import UIKit

protocol VaultTabBarControllerDelegate : NSObjectProtocol {
    func treasureAnnotations() -> [TreasureAnnotation]
    func showTargetLocations(_ ta: TreasureAnnotation)
    func hideTargetLocations()
}

class VaultTabBarController: UITabBarController {
    
    // MARK: Properties
    weak var vaultTabBarControllerDelegate: VaultTabBarControllerDelegate?
    
    // MARK: Properties
    var landmarkTableViewController: LandmarkTableViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let nc = viewControllers?[0] as? UINavigationController {
            landmarkTableViewController = nc.viewControllers[0] as? LandmarkTableViewController
            if let tas = vaultTabBarControllerDelegate?.treasureAnnotations() {
                landmarkTableViewController?.vaultTabBarControllerDelegate = vaultTabBarControllerDelegate
                landmarkTableViewController?.treasureAnnotations = tas
            }
        }
    }
}
