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

        
        SwiftSpinner.shared.outerColor = UIColor(rgb: appDefaultColor)
        SwiftSpinner.shared.innerColor = UIColor(rgb: appDefaultColor)
        SwiftSpinner.show("Loading...")
        
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
//        self.tabBarController?.selectedIndex = 0
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        //https://www.indianroti.co.uk/new-beta/confirm/?confirm_submit
        print(webView.url as Any)
        decisionHandler(.allow)
        DispatchQueue.main.async {
            SwiftSpinner.hide()
            
            let alert = UIAlertController(title: "Order Status", message: "Successfully Received", preferredStyle: UIAlertController.Style.alert)

            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
                 //Cancel Action
//                self.navigationController?.popToRootViewController(animated: false)
                self.tabBarController?.selectedIndex = 0
                AppManager.sharedInstance().cartDataArr.removeAll()
                AppManager.sharedInstance().cartProductDataArr.removeAll()
             }))

             self.present(alert, animated: true, completion: nil)
        }
        

//        if webView.url?.absoluteString == "https://www.indianroti.co.uk/new-beta/confirm/?confirm_submit" {

            
//        }

    }

}
