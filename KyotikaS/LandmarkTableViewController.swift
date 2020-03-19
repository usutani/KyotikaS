//
//  LandmarkTableViewController.swift
//  KyotikaS
//
//  Created by Yasuhiro Usutani on 2020/03/19.
//  Copyright © 2020 toolstudio. All rights reserved.
//

import UIKit

class LandmarkTableViewController: UITableViewController {
    
    // MARK: Properties
    weak var vaultTabBarControllerDelegate: VaultTabBarControllerDelegate?
    var treasureAnnotations: [TreasureAnnotation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let amount = treasureAnnotations.count
        let count = treasureAnnotations.filter { $0.find }.count
        title = "思い出した場所（\(count) / \(amount)）"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "完了", style: .done, target: self, action: #selector(type(of: self).tapDoneButton))
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView(frame: tableView.bounds)
        v.backgroundColor = .systemGray3
        
        let l = UILabel(frame: v.bounds.insetBy(dx: 20, dy: 10))
        l.lineBreakMode = .byCharWrapping
        l.numberOfLines = 0
        l.text = "項目をタップすると地図で場所が表示されます"
        l.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        v.addSubview(l)
        return v
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true, completion: nil)
        vaultTabBarControllerDelegate?.hideTargetLocations()
        vaultTabBarControllerDelegate?.showTargetLocations(treasureAnnotations[indexPath.row])
    }
    
    @objc private func tapDoneButton() {
        dismiss(animated: true, completion: nil)
        vaultTabBarControllerDelegate?.hideTargetLocations()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return treasureAnnotations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Landmark", for: indexPath)
        if treasureAnnotations[indexPath.row].passed {
            cell.textLabel?.text = treasureAnnotations[indexPath.row].landmark.name
        }
        else {
            cell.textLabel?.text = "?"
        }
        return cell
    }
}
