//
//  PhoneAuthController.swift
//  Thali&Pickles
//
//  Created by Emon on 3/8/20.
//  Copyright © 2020 TriTechFirm. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseAuth

class PhoneAuthController: BaseViewController {

    @IBOutlet weak var phoneTxtField: UITextField!
    @IBOutlet weak var otpTxtField: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        otpTxtField.isHidden = true
    }
    var verificationID : String? = nil
    
    @IBAction func sendBtnAction(_ sender: Any) {
        
        if  otpTxtField.isHidden == true {
            if phoneTxtField.text!.isEmpty == false {
                Auth.auth().settings?.isAppVerificationDisabledForTesting = true
                PhoneAuthProvider.provider().verifyPhoneNumber(phoneTxtField.text!, uiDelegate: nil) { (verificationId, error) in
                    if error != nil {
                        self.showAlertWithMessage(headerText: "Error", message: error!.localizedDescription)
                    }
                    else {
                        self.verificationID = verificationId
                        self.otpTxtField.isHidden = false
                    }
                }
            }
            else {
                self.showAlertWithMessage(headerText: "Error", message: "PLEASE ENTER PHONE NUMBER")
            }
        }
        else {
            if self.verificationID != nil {
                let credential = PhoneAuthProvider.provider().credential(withVerificationID: self.verificationID!, verificationCode: otpTxtField.text!)
                Auth.auth().signIn(with: credential) { (authData, error) in
                    if error == nil {
                        self.showAlertWithMessage(headerText: "Error", message: error!.localizedDescription)
                    }
                    else {
                        self.showAlertWithMessage(headerText: "SUCESS", message: "AUTH SUCESS WITH \(authData?.user.phoneNumber ?? "NO PHONE NUMBER FOUND")")
                    }
                    
                }
            }
            else {
                self.showAlertWithMessage(headerText: "Error", message: "ERROR IN GETING VERIFICATION CODE")

            }
        }
        
        
        
    }
    @IBAction func cancelBtnAction(_ sender: Any) {
        self.dismiss(animated: true) {
            
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
