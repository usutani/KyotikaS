//
//  KeywordTableViewController.swift
//  KyotikaS
//
//  Created by Yasuhiro Usutani on 2020/03/19.
//  Copyright © 2020 toolstudio. All rights reserved.
//

import UIKit

class KeywordTableViewController: UITableViewController {
    
    // MARK: Properties
    weak var keywordTableViewControllerDelegate: KeywordTableViewControllerDelegate?
    var tags: [Tag] = []
    var prologue: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "手がかり"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "完了", style: .done, target: self, action: #selector(type(of: self).tapDoneButton))
    }
    
    @objc private func tapDoneButton() {
        dismiss(animated: true, completion: nil)
        if prologue {
            keywordTableViewControllerDelegate?.zoomInIfPrologue()
        }
        else {
            keywordTableViewControllerDelegate?.hideTargetLocations()
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tags.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Tag", for: indexPath)
        cell.textLabel?.text = tags[indexPath.row].name
        return cell
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: indexPath, animated: true)
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailKeywordTableViewController
                controller.keywordTableViewControllerDelegate = keywordTableViewControllerDelegate
                let tag = tags[indexPath.row]
                if let tags = keywordTableViewControllerDelegate?.treasureAnnotationsForTag(tag: tag) {
                    controller.treasureAnnotations = tags
                    controller.tagName = tag.name ?? ""
                    controller.prologue = prologue
                }
            }
        }
    }
}
