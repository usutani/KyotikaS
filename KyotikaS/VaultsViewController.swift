//
//  VaultsViewController.swift
//  KyotikaS
//
//  Created by Yasuhiro Usutani on 2020/03/16.
//  Copyright © 2020 toolstudio. All rights reserved.
//

import UIKit

protocol VaultsViewControllerDelegate : NSObjectProtocol {
    func showTargetLocations(_ ta: TreasureAnnotation)
    func hideTargetLocations()
}

class VaultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Properties
    var treasureAnnotations: [TreasureAnnotation] = []
    @IBOutlet weak var navBar: UINavigationBar!
    weak var delegate: VaultsViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let amount = treasureAnnotations.count
        let count = treasureAnnotations.filter { $0.find }.count
        navBar.topItem?.title = "思い出した場所（\(count) / \(amount)）"
    }
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
        delegate?.hideTargetLocations()
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true, completion: nil)
        delegate?.hideTargetLocations()
        delegate?.showTargetLocations(treasureAnnotations[indexPath.row])
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return treasureAnnotations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
