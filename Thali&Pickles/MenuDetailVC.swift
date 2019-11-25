//
//  MenuDetailVC.swift
//  Thali&Pickles
//
//  Created by Emon on 11/25/19.
//  Copyright © 2019 Emon. All rights reserved.
//

import UIKit

class MenuDetailVC: UIViewController {
    
    let service = Service.sharedInstance()
    var itemDict = [String:Any]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        DispatchQueue.global(qos: .default).async(execute: {
            // time-consuming task
            self.service.getAllFoodCategory(requestURL: "\(baseURL)category/\(self.itemDict["id"] ?? 100)", onSuccess: { (result) in
                print(result)
//                if  let object = result as? [String:Any] {
//                    if let dataIteme = object["data"] as? [[String : Any]] {
//                        for anItem in dataIteme {
//                            self.items.append(anItem)
//                        }
//                    }
//
//                    print(self.items)
//                } else {
//                print("JSON is invalid")
//                }

            }) { (error) in
                print(error!)
            }
        })
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
