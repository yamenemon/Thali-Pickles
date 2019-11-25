//
//  MenuDetailVC.swift
//  Thali&Pickles
//
//  Created by Emon on 11/25/19.
//  Copyright © 2019 Emon. All rights reserved.
//

import UIKit

class MenuDetailVC: UIViewController {
    
    let tableView = UITableView()
    let service = Service.sharedInstance()
    var itemDict = [String:Any]()
    var items = [[String:Any]]()
    var safeArea: UILayoutGuide!
    var characters = ["Link", "Zelda", "Ganondorf", "Midna"]


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
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

    }
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
    
}
extension MenuDetailVC: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return characters.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    cell.textLabel?.text = characters[indexPath.row]
    return cell
  }
}
