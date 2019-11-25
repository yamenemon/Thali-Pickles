//
//  CartVC.swift
//  Thali&Pickles
//
//  Created by Emon on 26/11/19.
//  Copyright © 2019 Emon. All rights reserved.
//

import UIKit

class CartVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let countedSet = NSCountedSet(array: AppManager.sharedInstance().cartDataArr)
        for value in countedSet {
//            print("Element:", value, "count:", countedSet.count(for: value))
            AppManager.sharedInstance().cartProductDataArr.append(value as! [String : Any])
            AppManager.sharedInstance().cartProductCountArr.append(countedSet.count(for: value))
        }
        print(AppManager.sharedInstance().cartProductDataArr)
        print(AppManager.sharedInstance().cartProductCountArr)
        // Do any additional setup after loading the view.
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
