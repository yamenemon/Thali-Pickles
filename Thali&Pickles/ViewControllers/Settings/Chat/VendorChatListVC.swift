//
//  VendorChatListVC.swift
//  Thali&Pickles
//
//  Created by Emon on 25/7/20.
//  Copyright © 2020 TriTechFirm. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class VendorChatListVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.vendorArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60*factx
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CategoryCell
        tableView.separatorStyle = .none
        cell.selectionStyle = .none
        cell.infoBtn.isHidden = true
        cell.categoryPrice.isHidden = true
        cell.cartBtn.isHidden = true
        
        let vendor = self.vendorArr[indexPath.section]
        cell.categoryName.text = vendor.username
        
        return cell
    }
    

    var vendorList = UITableView()
    var safeArea: UILayoutGuide!
    var vendorArr = [Vendor]()
    override var hidesBottomBarWhenPushed: Bool {
        get {
            return navigationController?.topViewController == self
        }
        set {
            super.hidesBottomBarWhenPushed = newValue
        }
    }

    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        safeArea = view.layoutMarginsGuide
        setupTableView()
        loadVendorsList()
    }
    
    func loadVendorsList(){
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            print(snapshot)
            if let dict = snapshot.value as? [String: AnyObject] {
                let vendor = Vendor()
                vendor.address = dict["address"] as? String
                vendor.email = dict["email"] as? String
                vendor.password = dict["password"] as? String
                vendor.phone = dict["phone"] as? String
                vendor.username = dict["username"] as? String
                self.vendorArr.append(vendor)
                DispatchQueue.main.async {
                    self.vendorList.reloadData()
                }
            }
        }, withCancel: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        configureNavigationBar(largeTitleColor: .white, backgoundColor: UIColor(rgb: 0xFF9300), tintColor: UIColor(rgb: appDefaultColor), title: "বিক্রেতা সমূহ", preferredLargeTitle: false)
        self.navigationItem.leftBarButtonItem = self.navigationItem.backBarButtonItem;
        self.navigationController?.navigationBar.tintColor = .white
    }
    func setupTableView() {
        vendorList = UITableView(frame: self.vendorList.frame, style: .grouped)
        view.addSubview(vendorList)
        vendorList.translatesAutoresizingMaskIntoConstraints = false
        vendorList.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        vendorList.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        vendorList.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        vendorList.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        vendorList.delegate = self
        vendorList.dataSource = self
        vendorList.tableFooterView = UIView()
        vendorList.register(UINib(nibName: "CategoryCell", bundle: nil), forCellReuseIdentifier: "Cell")
    }

}
