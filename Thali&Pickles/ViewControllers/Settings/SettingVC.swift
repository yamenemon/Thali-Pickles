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

class SettingVC: BaseViewController {

    let arrUserList = NSMutableArray()
    let arr = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        let ref = Database.database().reference()
//        ref.child("users").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with:  { (snapshot) in
//            if snapshot.exists()
//            {
//                if let fruitPost = snapshot.value as? Dictionary<String,AnyObject>
//                {
//                    for(key, value) in fruitPost {
//                        if(Auth.auth().currentUser!.uid != key){
//                            let dict = NSMutableDictionary()
//                            dict.setObject(value, forKey:"firebaseId" as NSCopying)
//                            self.arrUserList.add(dict)
//                        }
//                    }
//                }
//                print(self.arrUserList)
//                
//            }
//            else {
//                print("not available")
//            }
//        })
    }

    @IBAction func chatWithVendor(_ sender: Any) {
        let chatVC = ChatVC()
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
    
    @IBAction func logoutBtnAction(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            self.navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
            self.showToastAtWindow(text: "\(signOutError)")
        }
        
    }
    
}
