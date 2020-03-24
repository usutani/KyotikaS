//
//  HelpTabBarViewController.swift
//  KyotikaS
//
//  Created by Yasuhiro Usutani on 2020/03/24.
//  Copyright © 2020 toolstudio. All rights reserved.
//

import UIKit

class HelpTabBarViewController: UIViewController {
    
    weak var vaultTabBarControllerDelegate: VaultTabBarControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "これまでのお話"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "完了", style: .done, target: self, action: #selector(type(of: self).tapDoneButton))
    }
    
    @objc private func tapDoneButton() {
        dismiss(animated: true, completion: nil)
        vaultTabBarControllerDelegate?.zoomInIfPrologue()
    }
}
