//
//  CartVC.swift
//  Thali&Pickles
//
//  Created by Emon on 26/11/19.
//  Copyright © 2019 Emon. All rights reserved.
//

import UIKit

class CartVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppManager.sharedInstance().cartProductDataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CartTableViewCell
        
        let contentData = AppManager.sharedInstance().cartProductDataArr[indexPath.row]
        let contentAmount = AppManager.sharedInstance().cartProductCountArr[indexPath.row]

        let productName = contentData["sub_category_title"]
        cell.productNameLabel.text = "\(productName ?? "")"
        cell.productAmount.text = "\(contentAmount)"
        let productInfo = contentData["sub_category_products"] as! [String:Any]
        let productPrice = productInfo["product_price"]
        cell.priceLabel.text = "\(productPrice ?? "")"
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90*factx
    }
    
    @IBOutlet weak var calculationView: UIView!
    @IBOutlet weak var cartTableView: UITableView!
    
     
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
        cartTableView.tableFooterView = UIView()
        cartTableView.register(UINib(nibName: "CartTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
    }

}
