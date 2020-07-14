//
//  CheckOutVC.swift
//  Thali&Pickles
//
//  Created by Emon on 1/12/19.
//  Copyright © 2019 Emon. All rights reserved.
//

import UIKit
import WebKit
import SwiftSpinner
import Toast_Swift


class CheckOutVC: UIViewController,WKNavigationDelegate,UITabBarControllerDelegate {

    var checkOutUrl = ""
    var webView: WKWebView!

    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        configureNavigationBar(largeTitleColor: .white, backgoundColor: UIColor(rgb: 0xFF9300), tintColor: UIColor.white, title: "Checkout", preferredLargeTitle: true)
        
        // Do any additional setup after loading the view.
        let url = URL(string: checkOutUrl)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        SwiftSpinner.hide()
        
        webView.evaluateJavaScript("document.getElementById(\"header\").style.display='none';") { (result, error) in
            if result != nil {
             print(result ?? "")
            }
            else {
             print(error ?? "")

             }
        }
        webView.evaluateJavaScript("document.getElementById(\"footer-area\").style.display='none';") { (result, error) in
            if result != nil {
             print(result ?? "")
            }
            else {
             print(error ?? "")

             }
        }
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        //https://www.indianroti.co.uk/new-beta/confirm/?confirm_submit
        print(webView.url as Any)
        decisionHandler(.allow)
        
        if webView.url?.absoluteString == "https://www.indianroti.co.uk/new-beta/confirm/?confirm_submit" {
            DispatchQueue.main.async {
                SwiftSpinner.hide()
                AppManager.sharedInstance().cartDataArr.removeAll()
                AppManager.sharedInstance().cartProductDataArr.removeAll()
                AppManager.sharedInstance().cartProductCountArr.removeAll()
                AppManager.sharedInstance().successfullyDelivered = true
                self.navigationController?.popToRootViewController(animated: false)
            }
        }

    }

}
