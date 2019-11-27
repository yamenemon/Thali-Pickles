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
        
        getData()
    }
    func getData() {
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
    override func viewWillAppear(_ animated: Bool) {

    }
    
    func addToCartBtnActionDelegate(sender: UIButton) {
        let numberOfCartValue = AppManager.sharedInstance().cartDataArr.count + 1
        tabBarController?.tabBar.items?[1].badgeColor = .black
        tabBarController?.tabBar.items?[1].badgeValue = "\(numberOfCartValue)"
        
        let contentData = self.items[sender.tag]
        AppManager.sharedInstance().cartDataArr.append(contentData)
//        print(AppManager.sharedInstance().cartDataArr)
        
        AppManager.sharedInstance().cartProductDataArr.removeAll()
        AppManager.sharedInstance().cartProductCountArr.removeAll()
        
        let countedSet = NSCountedSet(array: AppManager.sharedInstance().cartDataArr)
        for value in countedSet {
            AppManager.sharedInstance().cartProductDataArr.append(value as! [String : Any])
            AppManager.sharedInstance().cartProductCountArr.append(Double(countedSet.count(for: value)))
        }
    }
}
extension MenuDetailVC: UITableViewDataSource,UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.items.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CategoryCell
    cell.delegate = self

    let contentData = self.items[indexPath.row]
    
    let productName = contentData["sub_category_title"]
    let productDescription = contentData["sub_category_description"]
    
    let productInfo = contentData["sub_category_products"] as! [String:Any]
    let productPrice = productInfo["product_price"]

    cell.categoryName.text = productName as? String
    cell.categoryPrice.text = "£ \(productPrice as? String ?? "")"
    cell.categoryDescription.text = productDescription as? String
    
    cell.cartBtn.tag = indexPath.row

    return cell
  }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65*factx
    }
}
