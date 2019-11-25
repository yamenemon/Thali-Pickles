//
//  MenuDetailVC.swift
//  Thali&Pickles
//
//  Created by Emon on 11/25/19.
//  Copyright © 2019 Emon. All rights reserved.
//

import UIKit
import SwiftSpinner

class MenuDetailVC: UIViewController,addToCartDelegate {

    let tableView = UITableView()
    let service = Service.sharedInstance()
    var itemDict = [String:Any]()
    var items = [[String:Any]]()
    var safeArea: UILayoutGuide!
    var numberOfCartValue = 0

    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        safeArea = view.layoutMarginsGuide
        setupTableView()
    }
    func setupTableView() {
      view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "CategoryCell", bundle: nil), forCellReuseIdentifier: "Cell")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        let navTitle = itemDict["title"] as? String ?? "Menu Details"
        
        configureNavigationBar(largeTitleColor: .white, backgoundColor: UIColor(rgb: 0xFF9300), tintColor: UIColor(rgb: appDefaultColor), title: navTitle, preferredLargeTitle: true)
        self.navigationItem.leftBarButtonItem = self.navigationItem.backBarButtonItem;
        self.navigationController?.navigationBar.tintColor = .white
        SwiftSpinner.shared.outerColor = UIColor(rgb: appDefaultColor)
        SwiftSpinner.shared.innerColor = UIColor(rgb: appDefaultColor)
        SwiftSpinner.show("Loading...")
    }
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.global(qos: .default).async(execute: {
            // time-consuming task
            ///products_by_category/{category_id}
            let contentUrl = "\(baseURL)products_by_category/\(self.itemDict["id"] ?? 100)"
            self.service.getAllFoodCategory(requestURL: contentUrl, onSuccess: { (result) in
                if  let object = result as? [String:Any] {
                    if let dataIteme = object["data"] as? [[String : Any]] {
                        for anItem in dataIteme {
                            self.items.append(anItem)
                        }
                    }
                    DispatchQueue.main.async {
                        SwiftSpinner.hide()
                        self.tableView.reloadData()
                    }
                    print(self.items)
                } else {
                print("JSON is invalid")
                }


            }) { (error) in
                print(error!)
            }
        })
    }
    
    func addToCartBtnActionDelegate(sender: UIButton) {
        print(sender.tag)
        numberOfCartValue = numberOfCartValue + 1
        tabBarController?.tabBar.items?[1].badgeColor = .black
        tabBarController?.tabBar.items?[1].badgeValue = "\(numberOfCartValue)"
    }
    
}
extension MenuDetailVC: UITableViewDataSource,UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.items.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CategoryCell
    cell.delegate = self

    /*
     sub_category_title  => product_name
     sub_category_description => product_description
     sub_category_products[product_id] => product_id
     sub_category_products[product_price] => product_price
     */
    
    let contentData = self.items[indexPath.row]
    let productInfo = contentData["sub_category_products"] as! [String:Any]
//    let productId = productInfo["product_id"] as! Int
    
    let productName = contentData["sub_category_title"]
    let productDescription = contentData["sub_category_description"]
    let productPrice = productInfo["product_price"]

    
    cell.categoryName.text = productName as? String
    cell.categoryPrice.text = "£ \(productPrice as? String ?? "")"
    cell.categoryDescription.text = productDescription as? String
    if let productId = ( productInfo["product_id"] as? NSString)?.doubleValue {
      // here, totalfup is a Double
        cell.cartBtn.tag = Int(productId)

    }
    else {
      // dict["totalfup"] isn't a String

    }
    
    return cell
  }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65*factx
    }
}
