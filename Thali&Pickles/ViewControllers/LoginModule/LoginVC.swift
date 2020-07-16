//
//  LoginVC.swift
//  Thali&Pickles
//
//  Created by Emon on 14/7/20.
//  Copyright © 2020 Emon. All rights reserved.
//

import UIKit
import Alamofire
import SwiftSpinner

class LoginVC: BaseViewController {
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= 200
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @IBAction func loginBtnAction(_ sender: Any) {
        
        SwiftSpinner.show("Registration On Progress...")
        let urlString = "\(baseURL)/user_login"
        let headers: HTTPHeaders = ["Accept":"application/json"]
        var apiError = ApiError(
            error: "",
            message: "System Error"
        )
        /*
         name,email,password,phone, postcode, house_no, address
         */
        
        var parameters: [String: Any] = [:]
        parameters["email"] = emailTF.text
        parameters["password"] = passwordTF.text
        
        AF.request(urlString,method: .post, parameters: parameters, headers: headers)
            .validate(statusCode:200..<600)
            .responseJSON{ res in
                switch res.result {
                    case let .success(value):
                        if let dataDict = value as? [String:Any] {
                            let status = dataDict["status"] as? Bool ?? false
                            let message = dataDict["errors"] as? String ?? ""
                            if !status {
                                apiError.error = "Status Error"
                                apiError.message = message
                                self.showAlertWithMessage(headerText: "\(apiError.error)", message: apiError.message)
                                SwiftSpinner.hide()
                                return
                            }
                            _ = try? JSONSerialization.data(withJSONObject: dataDict, options: .prettyPrinted)
                            do {
                                SwiftSpinner.hide()
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let tbc = storyboard.instantiateViewController(withIdentifier:"tabbarController") as! UITabBarController
                                tbc.selectedIndex = 0
                                self.present(tbc, animated: true, completion:nil)
                            } catch (let error) {
                                print(error)
                                SwiftSpinner.hide()
                                
                                var apiError = ApiError(error: "")
                                apiError.error = "Json conversion Error"
                                apiError.message = error.localizedDescription
                                self.showAlertWithMessage(headerText: "\(apiError.error)", message: apiError.message)
                                return
                            }
                            
                    }
                    case let .failure(error):
                        print(error)
                        SwiftSpinner.hide()
                        var apiError = ApiError(error: "")
                        apiError.error = "Api Error"
                        apiError.message = error.localizedDescription
                        self.showAlertWithMessage(headerText: "\(apiError.error)", message: apiError.message)
                }
        }
    }
}
