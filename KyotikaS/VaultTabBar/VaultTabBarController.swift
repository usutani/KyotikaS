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
    func allPassedTags() -> [Tag]
    func treasureAnnotationsForTag(tag: Tag) -> [TreasureAnnotation]
    func showRelatedTargetLocations(_ ta: TreasureAnnotation)
    func showTargetLocations(tagName: String, treasureAnnotation: [TreasureAnnotation])
    func hideTargetLocations()
}

class VaultTabBarController: UITabBarController {
    
    // MARK: Properties
    weak var vaultTabBarControllerDelegate: VaultTabBarControllerDelegate?
    var landmarkTableViewController: LandmarkTableViewController?
    var keywordTableViewController: KeywordTableViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let nc = viewControllers?[0] as? UINavigationController {
            landmarkTableViewController = nc.viewControllers[0] as? LandmarkTableViewController
            landmarkTableViewController?.vaultTabBarControllerDelegate = vaultTabBarControllerDelegate
            if let tas = vaultTabBarControllerDelegate?.treasureAnnotations() {
                landmarkTableViewController?.treasureAnnotations = tas
            }
        }
        if let nc = viewControllers?[1] as? UINavigationController {
            keywordTableViewController = nc.viewControllers[0] as? KeywordTableViewController
            keywordTableViewController?.vaultTabBarControllerDelegate = vaultTabBarControllerDelegate
            if let tags = vaultTabBarControllerDelegate?.allPassedTags() {
                keywordTableViewController?.tags = tags
            }
        }
    }
}
