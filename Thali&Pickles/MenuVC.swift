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

    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    var items = [[String:Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureNavigationBar(largeTitleColor: .white, backgoundColor: UIColor(rgb: 0xFF9300), tintColor: UIColor(rgb: appDefaultColor), title: "Menu", preferredLargeTitle: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10*factx, left: 10*factx, bottom: 10*factx, right: 10*factx)
        layout.itemSize = CGSize(width: 145*factx, height: 145*factx)
        
        menuCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height), collectionViewLayout: layout)
        view.addSubview(menuCollectionView)
        menuCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        menuCollectionView.delegate = self
        menuCollectionView.dataSource = self
        menuCollectionView.backgroundColor = .white
        
        SwiftSpinner.shared.outerColor = UIColor(rgb: appDefaultColor)
        SwiftSpinner.shared.innerColor = UIColor(rgb: appDefaultColor)
        SwiftSpinner.show("Loading...")
        
        
        items.removeAll()
        DispatchQueue.global(qos: .default).async(execute: {
            // time-consuming task
            self.service.getAllGetRequest(requestURL: "\(baseURL)category", onSuccess: { (result) in
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
        cell.backgroundColor = UIColor.clear // make cell more visible in our example project
        let contentData = self.items[indexPath.row]
        let url = contentData["image"] as! String
        print(url)
        let cellImageView = PortImgView(frame: CGRect(x: 0, y: 0, width: cell.contentView.frame.size.width, height: cell.contentView.frame.size.height))
        cellImageView.setImgWith(URL(string: url ), placeholderImage: nil)
        cellImageView.backgroundColor = .red
        cell.contentView.addSubview(cellImageView)
        
        let cellTitle = contentData["title"] as! String

        let cellName = UILabel(frame: CGRect(x: 5*factx, y: 0, width: cellImageView.frame.size.width - 10*factx, height: cellImageView.frame.size.height))
        cellImageView.addSubview(cellName)
        cellName.backgroundColor = .clear//UIColor(rgb: appDefaultColor)
        cellName.textAlignment = .center
        cellName.textColor = .white
        cellName.font = UIFont(name: robotoBold, size: 13*factx)
        cellName.text = cellTitle
        cellName.numberOfLines = 3
        

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
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: largeTitleColor]
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
