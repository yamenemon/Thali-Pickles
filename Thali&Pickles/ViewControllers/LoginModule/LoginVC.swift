//
//  LoginVC.swift
//  Thali&Pickles
//
//  Created by Emon on 14/7/20.
//  Copyright © 2020 Emon. All rights reserved.
//

import UIKit
import Alamofire
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import GoogleSignIn
import SwiftSpinner
import FacebookCore
import FacebookLogin
import FBSDKLoginKit

class LoginVC: BaseViewController,GIDSignInDelegate {
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    var ref: DatabaseReference!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        guard let auth = user.authentication else { return }
        let credentials = GoogleAuthProvider.credential(withIDToken: auth.idToken, accessToken: auth.accessToken)
        Auth.auth().signIn(with: credentials) { (authResult, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Login Successful.")
                //This is where you should add the functionality of successful login
                //i.e. dismissing this view or push the home view controller etc
                
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let tbc = storyboard.instantiateViewController(withIdentifier:"tabbarController") as! UITabBarController
                tbc.selectedIndex = 0
                self.navigationController?.pushViewController(tbc, animated: true)
            }
        }
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
    @IBAction func gmailLogin(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()

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
        parameters["login_email"] = emailTF.text
        parameters["login_password"] = passwordTF.text
        
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
                            let dataDicts = try? JSONSerialization.data(withJSONObject: dataDict, options: .prettyPrinted)
                            do {
                                print(dataDicts!)
                                SwiftSpinner.hide()
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let tbc = storyboard.instantiateViewController(withIdentifier:"tabbarController") as! UITabBarController
                                tbc.selectedIndex = 0
                                self.navigationController?.pushViewController(tbc, animated: true)
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
    @IBAction func btnActionLoginWithFb(_ sender: Any) {
        
        let fbLoginManager : LoginManager = LoginManager()
        fbLoginManager.logIn(permissions: ["email"], from: self) { (result, error) in
            if (error == nil){
                let fbloginresult : LoginManagerLoginResult = result!
                if fbloginresult.grantedPermissions != nil {
                    if(fbloginresult.grantedPermissions.contains("email")) {
                        if((AccessToken.current) != nil){
                            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                                if (error == nil){
                                    let dict = result as! NSDictionary
                                    let firstName = ["Firstname": dict.object(forKey: "first_name") as! String , "Lastname": dict.object(forKey: "last_name")as! String]
                                    let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current?.tokenString ?? "")
                                    Auth.auth().signIn(with: credential) { (authResult, error) in
                                        if error != nil {
                                            var apiError = ApiError(error: "")
                                            apiError.error = "Sign In Error"
                                            apiError.message = error!.localizedDescription
                                            self.showAlertWithMessage(headerText: "\(apiError.error)", message: apiError.message)
                                            return
                                        }
                                        self.ref = Database.database().reference()
                                        let imgDict = dict .object(forKey: "picture") as! NSDictionary
                                        let imgData = imgDict .object(forKey: "data") as! NSDictionary
                                        let img = imgData .object(forKey: "url") as! NSString
                                        if let url = URL(string: img as String) {
                                            var data = try? Data(contentsOf: url)
                                            let image: UIImage = UIImage(data: data!)!
                                            data = image.jpegData(compressionQuality: 0.8)! as NSData as Data
                                            let storageRef = Storage.storage().reference()
                                            let filePath = "\(Auth.auth().currentUser!.uid)/\("imgUserProfile")"
                                            let metaData = StorageMetadata()
                                            metaData.contentType = "image/jpg"
                                            storageRef.child(filePath).putData((data)!, metadata: metaData){(metaData,error) in
                                                if let error = error {
                                                    print(error.localizedDescription)
                                                    return
                                                }
                                            }
                                        }
                                        self.ref.child("users").child(Auth.auth().currentUser!.uid).setValue(["username": firstName])
                                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                        let tbc = storyboard.instantiateViewController(withIdentifier:"tabbarController") as! UITabBarController
                                        tbc.selectedIndex = 0
                                        self.navigationController?.pushViewController(tbc, animated: true)
                                    }
//                                    Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
//
//                                        self.ref.child("users").child(Auth.auth().currentUser!.uid).setValue(["username": firstName])
//                                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                                        appDelegate.sideMenu()
//                                    }
                                }
                            })
                        }
                    }
                }
            }
        }
    }

}
