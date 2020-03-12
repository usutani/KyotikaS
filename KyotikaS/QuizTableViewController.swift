//
//  QuizTableViewController.swift
//  KyotikaS
//
//  Created by Yasuhiro Usutani on 2020/03/10.
//  Copyright © 2020 toolstudio. All rights reserved.
//

import UIKit

protocol QuizTableViewControllerDelegate : NSObjectProtocol {
    func quizTableViewControllerAnswer(_ view: QuizTableViewController)
}

class QuizTableViewController: UITableViewController {
    
    // MARK: Properties
    var question: String = ""
    var answers: [String] = []
    weak var delegate: QuizTableViewControllerDelegate?
    var selectedIndex = -1
    var userRef: TreasureAnnotation? = nil
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Quiz", for: indexPath)
        cell.textLabel?.text = answers[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView(frame: tableView.bounds)
        
        let l = UILabel(frame: v.bounds.insetBy(dx: 20, dy: 10))
        l.lineBreakMode = .byCharWrapping
        l.numberOfLines = 0
        l.text = question
        l.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        v.addSubview(l)
        return v
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let v = UIView(frame: tableView.bounds)
        
        let l = UILabel(frame: v.bounds.insetBy(dx: 20, dy: 0))
        l.lineBreakMode = .byCharWrapping
        l.numberOfLines = 0
        l.textColor = .darkGray
        l.text = "慎重に〜、間違えると\n2分間チャレンジできなくなるワン"
        l.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        v.addSubview(l)
        return v
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        dismiss(animated: true, completion: nil)
        delegate?.quizTableViewControllerAnswer(self)
    }
}
