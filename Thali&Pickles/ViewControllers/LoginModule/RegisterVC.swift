//
//  RegisterVC.swift
//  Thali&Pickles
//
//  Created by Emon on 14/7/20.
//  Copyright © 2020 Emon. All rights reserved.
//

import UIKit
import Alamofire
import SwiftSpinner
import FirebaseAuth
import FirebaseDatabase

class RegisterVC: BaseViewController,UITextFieldDelegate {
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var addressTF: UITextField!
    
    var ref: DatabaseReference!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func registerBtnAction(_ sender: Any) {
        
        SwiftSpinner.show("Registration On Progress...")
        let urlString = "\(baseURL)/user_registration"
        let headers: HTTPHeaders = ["Accept":"application/json"]
        var apiError = ApiError(
            error: "",
            message: "System Error"
        )
        /*
         name,email,password,phone, postcode, house_no, address
         */
        
        var parameters: [String: Any] = [:]
        parameters["name"] = nameTF.text
        parameters["email"] = emailTF.text
        parameters["password"] = password.text
        parameters["phone"] = phoneTF.text
        parameters["address"] = addressTF.text
        
        guard let name = nameTF.text, let email = emailTF.text, let pass = password.text, let phone = phoneTF.text, let address = addressTF.text else {
            self.showAlertWithMessage(headerText: "Validate Error", message: "Please fill up all field")
            return
        }
        
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
                            print("Successfully User saved to server".capitalized)
                            Auth.auth().createUser(withEmail: email, password: pass) { (authResult, error) in
                                if error != nil {
                                    SwiftSpinner.hide()
                                    var apiError = ApiError(error: "")
                                    apiError.error = "Json conversion Error"
                                    apiError.message = error!.localizedDescription
                                    self.showAlertWithMessage(headerText: "\(apiError.error)", message: apiError.message)
                                    return
                                }
                                print("Successfully User saved to firebase".capitalized)
                                guard let uid = authResult?.user.uid else {
                                    return
                                }
                                self.ref = Database.database().reference()
                                let userReference = self.ref.child("users").child(uid)
                                let values = ["username":name,"email":email,"password":pass, "phone":phone, "address":address]
                                userReference.updateChildValues(values) { (err, referrance) in
                                    SwiftSpinner.hide()
                                    if err != nil {
                                        return
                                    }
                                    print("Successfully User information saved to firebase database".capitalized)

                                    self.navigationController?.popViewController(animated: true)
                                    self.showToastAtWindow(text: "Registration successful")
                                }
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        textField.setValue(UIColor.clear, forKeyPath: "_placeholderLabel.textColor")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
//        if #available(iOS 13.0, *) {
//            textField.setValue(UIColor.placeholderText, forKeyPath: "_placeholderLabel.textColor")
//        } else {
//            // Fallback on earlier versions
//        }
    }
    
}
