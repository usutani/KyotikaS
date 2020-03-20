//
//  LandmarkInfoViewController.swift
//  KyotikaS
//
//  Created by Yasuhiro Usutani on 2020/03/20.
//  Copyright © 2020 toolstudio. All rights reserved.
//

import UIKit
import WebKit

class LandmarkInfoViewController: UIViewController, WKNavigationDelegate {
    
    // MARK: Properties
    var landmarkName = ""
    var landmarkURL = ""
    var webView: WKWebView? = nil
    var activitiIndicator: UIActivityIndicatorView? = nil
    var errorLabel: UILabel? = nil
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView?.navigationDelegate = self
        view = webView
        
        activitiIndicator = UIActivityIndicatorView(style: .large)
        activitiIndicator?.color = .darkGray
        webView?.addSubview(activitiIndicator!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = landmarkName
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "完了", style: .done, target: self, action: #selector(type(of: self).tapDoneButton))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if landmarkURL == "" {
            return
        }
        activitiIndicator?.frame = webView!.bounds
        let encodeUrlString = landmarkURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        webView?.load(URLRequest(url: URL(string: encodeUrlString)!))
    }
    
    @objc private func tapDoneButton() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: WKNavigationDelegate
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        errorLabel?.removeFromSuperview()
        errorLabel = nil
        activitiIndicator?.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activitiIndicator?.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError: Error) {
        activitiIndicator?.stopAnimating()
        errorLabel = UILabel(frame: webView.bounds)
        webView.addSubview(errorLabel!)
        errorLabel?.text = "読み込みに失敗しました。"
    }
}
