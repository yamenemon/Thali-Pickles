//
//  SettingVC.swift
//  Thali&Pickles
//
//  Created by Emon on 17/7/20.
//  Copyright © 2020 Emon. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SettingVC: UIViewController {

    let arrUserList = NSMutableArray()
    let arr = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.configureNavigationBar(largeTitleColor: .white, backgoundColor: UIColor(rgb: 0xFF9300), tintColor: UIColor(rgb: appDefaultColor), title: "সেটিংস", preferredLargeTitle: false)

    }
    
    override func viewWillAppear(_ animated: Bool) {

    }

    @IBAction func chatWithVendor(_ sender: Any) {
        let navViewController = self.tabBarController?.selectedViewController as? UINavigationController
        let vendorListVC = VendorChatListVC()
        navViewController?.pushViewController(vendorListVC, animated: true)
    }
    
    @IBAction func logoutBtnAction(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            DispatchQueue.main.async {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let tbc = storyboard.instantiateViewController(withIdentifier:"loginController") as! UINavigationController
                let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
                keyWindow?.rootViewController = tbc
                keyWindow?.makeKeyAndVisible()
            }
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
//            self.showToastAtWindow(text: "\(signOutError)")
        }
        
    }
    
}
