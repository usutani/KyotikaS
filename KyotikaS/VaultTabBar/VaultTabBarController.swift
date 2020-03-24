//
//  VaultTabBarController.swift
//  KyotikaS
//
//  Created by Yasuhiro Usutani on 2020/03/19.
//  Copyright © 2020 toolstudio. All rights reserved.
//

import UIKit

protocol VaultTabBarControllerDelegate : KeywordTableViewControllerDelegate {
    func treasureAnnotations() -> [TreasureAnnotation]
    func allPassedTags() -> [Tag]
}

class VaultTabBarController: UITabBarController {
    
    // MARK: Properties
    weak var vaultTabBarControllerDelegate: VaultTabBarControllerDelegate?
    var landmarkTableViewController: LandmarkTableViewController?
    var keywordTableViewController: KeywordTableViewController?
    var helpTabBarViewController: HelpTabBarViewController?
    var prologue: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        if let nc = viewControllers?[0] as? UINavigationController {
            landmarkTableViewController = nc.viewControllers[0] as? LandmarkTableViewController
            landmarkTableViewController?.vaultTabBarControllerDelegate = vaultTabBarControllerDelegate
            if let tas = vaultTabBarControllerDelegate?.treasureAnnotations() {
                landmarkTableViewController?.treasureAnnotations = tas
            }
            landmarkTableViewController?.prologue = prologue
        }
        if let nc = viewControllers?[1] as? UINavigationController {
            keywordTableViewController = nc.viewControllers[0] as? KeywordTableViewController
            keywordTableViewController?.keywordTableViewControllerDelegate = vaultTabBarControllerDelegate
            if let tags = vaultTabBarControllerDelegate?.allPassedTags() {
                keywordTableViewController?.tags = tags
            }
            keywordTableViewController?.prologue = prologue
        }
        if let nc = viewControllers?[2] as? UINavigationController {
            helpTabBarViewController = nc.viewControllers[0] as? HelpTabBarViewController
            helpTabBarViewController?.vaultTabBarControllerDelegate = vaultTabBarControllerDelegate
        }
    }
}
