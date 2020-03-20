//
//  DetailKeywordTableViewController.swift
//  KyotikaS
//
//  Created by Yasuhiro Usutani on 2020/03/19.
//  Copyright © 2020 toolstudio. All rights reserved.
//

import UIKit

class DetailKeywordTableViewController: UITableViewController {
    
    // MARK: Properties
    weak var keywordTableViewControllerDelegate: KeywordTableViewControllerDelegate?
    var treasureAnnotations: [TreasureAnnotation] = []
    var tagName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "手がかり（\(tagName)）"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "戻る", style: .done, target: self, action: #selector(type(of: self).tapDoneButton))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "全て表示", style: .plain, target: self, action: #selector(type(of: self).tapShowAllButton))
    }
    
    @objc private func tapDoneButton() {
        dismiss(animated: true, completion: nil)
        keywordTableViewControllerDelegate?.hideTargetLocations()
    }
    
    @objc private func tapShowAllButton() {
        view.window!.rootViewController?.dismiss(animated: true, completion: nil)
        keywordTableViewControllerDelegate?.showTargetLocations(tagName: tagName, treasureAnnotation: treasureAnnotations)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.window!.rootViewController?.dismiss(animated: true, completion: nil)
        keywordTableViewControllerDelegate?.hideTargetLocations()
        keywordTableViewControllerDelegate?.showRelatedTargetLocations(treasureAnnotations[indexPath.row])
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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
 */
}
