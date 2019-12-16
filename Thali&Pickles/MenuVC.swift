//
//  MenuVC.swift
//  Thali&Pickles
//
//  Created by Emon on 24/11/19.
//  Copyright © 2019 Emon. All rights reserved.
//

import UIKit
import SwiftSpinner

class MenuVC: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {

    let service = Service.sharedInstance()
    var menuCollectionView: UICollectionView!
    var refresher:UIRefreshControl!


    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    var items = [[String:Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureNavigationBar(largeTitleColor: .white, backgoundColor: UIColor(rgb: 0xFF9300), tintColor: UIColor(rgb: appDefaultColor), title: "Menu", preferredLargeTitle: true)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        if (menuCollectionView != nil && self.items.count>0) {
            menuCollectionView.reloadData()
        }
        else {
            loadMenuItems()
        }
    }
    func loadMenuItems() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10*factx, left: 10*factx, bottom: 10*factx, right: 10*factx)
        //        layout.itemSize = CGSize(width: 150*factx, height: 150*factx)
        layout.itemSize = CGSize(width: (self.view.frame.size.width - 30*factx)*0.5, height: (self.view.frame.size.width - 30*factx)*0.5)

        menuCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height), collectionViewLayout: layout)
        view.addSubview(menuCollectionView)
        menuCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        menuCollectionView.delegate = self
        menuCollectionView.dataSource = self
        menuCollectionView.backgroundColor = .white
        
        self.refresher = UIRefreshControl()
        self.menuCollectionView!.alwaysBounceVertical = true
        self.refresher.tintColor = UIColor.red
        self.refresher.addTarget(self, action: #selector(loadData), for: .valueChanged)
        self.menuCollectionView!.refreshControl = refresher
        
        self.refresher.tintColor = UIColor(red: 155/255, green: 155/255, blue: 154/255, alpha: 1)
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white,NSAttributedString.Key.font:UIFont(name: robotoBold, size: 13*factx)]
        let attributedTitle = NSAttributedString(string: "Pulling More Foods...", attributes: attributes as [NSAttributedString.Key : Any])
        self.refresher.attributedTitle = attributedTitle
                
        SwiftSpinner.shared.outerColor = UIColor(rgb: appDefaultColor)
        SwiftSpinner.shared.innerColor = .white//UIColor(rgb: appDefaultColor)
        SwiftSpinner.show("Pulling Your Foods...")
        loadData()
    }
    @objc func loadData(){
        self.menuCollectionView!.refreshControl?.beginRefreshing()

        DispatchQueue.global(qos: .default).async(execute: {
            // time-consuming task
            self.service.getAllGetRequest(requestURL: "\(baseURL)category", onSuccess: { (result) in
                self.items.removeAll()
                if  let object = result as? [String:Any] {
                    if let dataIteme = object["data"] as? [[String : Any]] {
                        for anItem in dataIteme {
                            self.items.append(anItem)
                        }
                    }
                    DispatchQueue.main.async {
                        self.menuCollectionView.reloadData()
                        SwiftSpinner.hide()
                    }
                    print(self.items)
                } else {
                print("JSON is invalid")
                }

            }) { (error) in
                print(error!)
            }
        })
        stopRefresher()         //Call this to stop refresher
    }

    func stopRefresher() {
        self.menuCollectionView!.refreshControl?.endRefreshing()
    }
    // MARK: - UICollectionViewDataSource protocol

    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }

    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath)
        
        for content in cell.contentView.subviews {
            content.removeFromSuperview()
        }
//        cell.backgroundColor = UIColor.clear
//        cell.contentView.layer.borderColor = UIColor.gray.cgColor
//        cell.contentView.layer.borderWidth = 1.0
//        cell.contentView.layer.cornerRadius = 5.0
        
//        cell.contentView.layer.shadowOffset = CGSize(width: 1, height: 0);
//        cell.contentView.layer.shadowColor = UIColor.black.cgColor
//        cell.contentView.layer.shadowRadius = 5;
//        cell.contentView.layer.shadowOpacity = 0.25;
//        cell.contentView.clipsToBounds = false
//        cell.contentView.layer.masksToBounds = false
        
        cell.contentView.layer.cornerRadius = 2.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true

        cell.layer.backgroundColor = UIColor.white.cgColor
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)//CGSizeMake(0, 2.0);
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
        
        
        let contentData = self.items[indexPath.row]
        let url = "placeholder.png"//contentData["image"] as! String
        print(url)
        let cellImageView = PortImgView(frame: CGRect(x: 3*factx, y: 3*factx, width: cell.contentView.frame.size.width - 6*factx, height: cell.contentView.frame.size.height - 44*factx))
        cellImageView.setImgWith(URL(string: url ), placeholderImage: UIImage(named: "placeholder.png"))
        cellImageView.tintColor = UIColor(rgb: appDefaultColor)
        cellImageView.contentMode = .scaleAspectFit
        cell.contentView.addSubview(cellImageView)
        
        let cellTitle = contentData["title"] as! String

        let cellName = UILabel(frame: CGRect(x: 0, y: cellImageView.frame.size.height, width: cell.contentView.frame.size.width, height: 50*factx))
        cell.contentView.addSubview(cellName)
        cellName.backgroundColor = UIColor(rgb: cellNameBackgroundColor)
        cellName.textAlignment = .center
        cellName.textColor = .white
        cellName.font = UIFont(name: robotoBold, size: 12*factx)
        cellName.text = cellTitle
        cellName.numberOfLines = 3
//        cellName.clipsToBounds = true
        

        return cell
    }

    // MARK: - UICollectionViewDelegate protocol

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        let contentData = self.items[indexPath.row]
        let detailVC = MenuDetailVC()
        detailVC.itemDict = contentData
        
//        self.tabBarController.viewControllers = [NSArray arrayWithObjects:navigationcontroller,secondViewController and so on, nil];
        
        let navViewController = self.tabBarController?.selectedViewController as? UINavigationController
        navViewController?.pushViewController(detailVC, animated: true)
//    self.tabBarController?.navigationController?.pushViewController(detailVC, animated: true)
        
    }

}

extension UIViewController {
    func configureNavigationBar(largeTitleColor: UIColor, backgoundColor: UIColor, tintColor: UIColor, title: String, preferredLargeTitle: Bool) {
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: largeTitleColor,.font:UIFont(name: robotoBold, size: 22*factx)!]
            navBarAppearance.titleTextAttributes = [.foregroundColor: largeTitleColor]
            navBarAppearance.backgroundColor = backgoundColor

            navigationController?.navigationBar.standardAppearance = navBarAppearance
            navigationController?.navigationBar.compactAppearance = navBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance

            navigationController?.navigationBar.prefersLargeTitles = preferredLargeTitle
            navigationController?.navigationBar.isTranslucent = false
            navigationController?.navigationBar.tintColor = tintColor
            navigationItem.title = title

        } else {
            // Fallback on earlier versions
            navigationController?.navigationBar.barTintColor = backgoundColor
            navigationController?.navigationBar.tintColor = tintColor
            navigationController?.navigationBar.isTranslucent = false
            navigationItem.title = title
        }
    }
    
}

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}
