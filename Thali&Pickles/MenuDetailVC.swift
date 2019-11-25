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
        view.backgroundColor = .white
        configureNavigationBar(largeTitleColor: .white, backgoundColor: UIColor(rgb: 0xFF9300), tintColor: UIColor(rgb: appDefaultColor), title: "Menu Detail", preferredLargeTitle: true)
        self.navigationItem.leftBarButtonItem = self.navigationItem.backBarButtonItem;
        self.navigationController?.navigationBar.tintColor = .white
        
    }
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.global(qos: .default).async(execute: {
            // time-consuming task
            let contentUrl = "\(baseURL)category/\(self.itemDict["id"] ?? 100)"
            self.service.getAllFoodCategory(requestURL: contentUrl, onSuccess: { (result) in
                print(result)


            }) { (error) in
                print(error!)
            }
        })
    }

}
