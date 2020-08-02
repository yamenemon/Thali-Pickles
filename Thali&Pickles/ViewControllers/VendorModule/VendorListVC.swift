//
//  VendorListVC.swift
//  Thali&Pickles
//
//  Created by Emon on 25/7/20.
//  Copyright © 2020 TriTechFirm. All rights reserved.
//

import UIKit
import FirebaseAuth

class VendorListVC : UIViewController, UITableViewDelegate,UITableViewDataSource, UISearchResultsUpdating {
    
    let tableData = ["Austria","Australia","Srilanka","Japan"]
    var filteredTableData = [String]()
    var resultSearchController = UISearchController()
    
    @IBOutlet weak var vendorTable: UITableView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        vendorTable.backgroundColor = .clear
        vendorTable.tableFooterView = UIView()
        vendorTable.register(UINib(nibName: "CategoryCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        self.resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
//            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            self.vendorTable.tableHeaderView = controller.searchBar
            return controller
        })()
        // Reload the table
        self.vendorTable.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (self.resultSearchController.isActive) {
            return self.filteredTableData.count
        }
        else {
            return self.tableData.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CategoryCell
        cell.backgroundColor = .clear
        if (self.resultSearchController.isActive) {
            tableView.separatorStyle = .none
            cell.selectionStyle = .none
            cell.infoBtn.isHidden = true
            cell.categoryPrice.isHidden = true
            cell.cartBtn.isHidden = true
            cell.categoryName.text = filteredTableData[indexPath.row]
            return cell
        }
            
        else {
            tableView.separatorStyle = .none
            cell.selectionStyle = .none
            cell.infoBtn.isHidden = true
            cell.categoryPrice.isHidden = true
            cell.cartBtn.isHidden = true
            cell.categoryName.text = tableData[indexPath.row]
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if Auth.auth().currentUser != nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tbc = storyboard.instantiateViewController(withIdentifier:"tabbarController") as! UITabBarController
            tbc.selectedIndex = 0
            self.navigationController?.pushViewController(tbc, animated: true)
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filteredTableData.removeAll(keepingCapacity: false)
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        let array = (tableData as NSArray).filtered(using: searchPredicate)
        filteredTableData = array as! [String]
        self.vendorTable.reloadData()
    }
}
