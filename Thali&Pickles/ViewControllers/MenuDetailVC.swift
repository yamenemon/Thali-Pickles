//
//  MenuDetailVC.swift
//  Thali&Pickles
//
//  Created by Emon on 11/25/19.
//  Copyright © 2019 Emon. All rights reserved.
//

import UIKit
import SwiftSpinner
import Toast_Swift

class MenuDetailVC: UIViewController,addToCartDelegate {

    var tableView = UITableView()
    let service = Service.sharedInstance()
    var itemDict = [String:Any]()
    var items = [[String:Any]]()
    var safeArea: UILayoutGuide!
    
    var blurEffectView = UIVisualEffectView()
    var popUpView = UIView()

    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        safeArea = view.layoutMarginsGuide
        setupTableView()
    }
    func setupTableView() {
        tableView = UITableView(frame: self.tableView.frame, style: .grouped)
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
        
        let navTitle = itemDict["title"] as? String ?? "বিস্তারিত পণ্য"
        
        configureNavigationBar(largeTitleColor: .white, backgoundColor: UIColor(rgb: 0xFF9300), tintColor: UIColor(rgb: appDefaultColor), title: navTitle, preferredLargeTitle: true)
        self.navigationItem.leftBarButtonItem = self.navigationItem.backBarButtonItem;
        self.navigationController?.navigationBar.tintColor = .white
        SwiftSpinner.shared.outerColor = UIColor(rgb: appDefaultColor)
        SwiftSpinner.shared.innerColor = .white//UIColor(rgb: appDefaultColor)
        SwiftSpinner.show("একটু অপেক্ষা করুন...")
        if Reachability.isConnectedToNetwork(){
            print("Internet Connection Available!")
            getData()
        }else{
            DispatchQueue.main.async {
                SwiftSpinner.hide()
                self.tableView.reloadData()
            }
            print("Internet Connection not Available!")
            let alert = UIAlertController(title: "দুঃখিত!!", message: "ইন্টারনেট কানেকশন নেই", preferredStyle: UIAlertController.Style.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler:nil))
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
    }
    func getData() {
        DispatchQueue.global(qos: .default).async(execute: {
            // time-consuming task
            ///products_by_category/{category_id}
            let contentUrl = "\(baseURL)/products_by_category/\(self.itemDict["id"] ?? 100)"
            self.service.getAllGetRequest(requestURL: contentUrl, onSuccess: { (result) in
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
                DispatchQueue.main.async {
                    SwiftSpinner.hide()
                    let alert = UIAlertController(title: "দুঃখিত!!", message: "\(error ?? "Server Error")", preferredStyle: UIAlertController.Style.alert)
                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler:nil))
                    // show the alert
                    self.present(alert, animated: true, completion: nil)
                }
            }
        })
    }
    override func viewWillAppear(_ animated: Bool) {

    }
    //MARK: - PROTOCOL METHODS
    
    func addToCartBtnActionDelegate(sender: UIButton) {
        let numberOfCartValue = AppManager.sharedInstance().cartDataArr.count + 1
        tabBarController?.tabBar.items?[1].badgeColor = .black
        tabBarController?.tabBar.items?[1].badgeValue = "\(numberOfCartValue)"

        let contentData = self.items[sender.tag]
        let productName = contentData["sub_category_title"]
        self.view.makeToast("\(productName ?? "") কার্টে সংযুক্ত করা হয়েছে")

        
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
    
    func infoBtnActionDelegate(sender: UIButton) {
        let contentData = self.items[sender.tag]
        let productDescription = contentData["sub_category_description"]
        
        popUpView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width - 60*factx, height: 300*factx))
        popUpView.backgroundColor = .white

        let window = UIApplication.shared.windows[0].rootViewController
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = (window?.view.bounds)!
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 0.5
        window?.view.addSubview(blurEffectView)
        
        window?.view.addSubview(popUpView)
        
        let closeBtn = UIButton(frame: CGRect(x: 10*factx, y: popUpView.frame.size.height - 45*factx, width: popUpView.frame.size.width - 20*factx, height: 35*factx))
        closeBtn.backgroundColor = UIColor(rgb: appDefaultColor)
        closeBtn.setTitle("বন্ধ করুন", for: .normal)
        closeBtn.addTarget(self, action: #selector(closeBtnAction), for: .touchUpInside)
        popUpView.addSubview(closeBtn)
        
        let textView = UITextView(frame:CGRect(x: 10*factx, y: 10*factx, width: popUpView.frame.size.width - 20*factx, height: popUpView.frame.size.height - 75*factx))
        textView.textAlignment = NSTextAlignment.left
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.black.cgColor
        textView.textAlignment = .left
        textView.isEditable = false
        textView.isScrollEnabled = true
        textView.showsVerticalScrollIndicator = true
        textView.isSelectable = false
        textView.textColor = .black
        textView.font = UIFont(name: robotoRegular, size: 15*factx)
        popUpView.addSubview(textView)
        textView.text = productDescription as? String ?? "কোন তথ্য নেই"
        
        
        popUpView.center = blurEffectView.center

    }
    @objc func closeBtnAction() {
        popUpView.removeFromSuperview()
        blurEffectView.removeFromSuperview()
    }
}
extension MenuDetailVC: UITableViewDataSource,UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.items.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CategoryCell
    cell.delegate = self
    tableView.separatorStyle = .none
    cell.selectionStyle = .none

    let contentData = self.items[indexPath.row]
    
    let productName = contentData["sub_category_title"]
    
    let productInfo = contentData["sub_category_products"] as! [String:Any]
    let productPrice = productInfo["product_price"]

    cell.categoryName.text = productName as? String
    cell.categoryPrice.text = "৳ \(productPrice as? String ?? "")"
//    cell.categoryDescription.text = productDescription as? String
    
    cell.cartBtn.tag = indexPath.row
    cell.infoBtn.tag = indexPath.row

    return cell
  }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80*factx
    }
}
