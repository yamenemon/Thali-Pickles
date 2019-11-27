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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.selectionStyle = .none
        
        let containerView = UIView(frame: CGRect(x: 10*factx, y: 10*factx, width: cell.contentView.frame.size.width - 20*factx, height: cell.contentView.frame.size.height - 20*factx))
        cell.contentView.addSubview(containerView)
        containerView.layer.cornerRadius = 5.0
        containerView.backgroundColor = UIColor(rgb: appDefaultColor)
        
        let contentData = AppManager.sharedInstance().cartProductDataArr[indexPath.row]
        let contentAmount = AppManager.sharedInstance().cartProductCountArr[indexPath.row]
        
        let productName = contentData["sub_category_title"]
        let productInfo = contentData["sub_category_products"] as! [String:Any]
        let productPrice = productInfo["product_price"]
        
        let verticalSpaceY = 5*factx
        let horizontalSpaceX = 5*factx
        let imageViewHeight = containerView.frame.size.height - verticalSpaceY*2;
        let imageViewWidth = imageViewHeight
        
        let productImageView = PortImgView(frame: CGRect(x: horizontalSpaceX, y: verticalSpaceY, width: imageViewWidth, height: imageViewHeight))
        containerView.addSubview(productImageView)
        let tempImage = "https://www.indianroti.co.uk/new-beta/category_photo/thum/no-image.png"
        productImageView.setImgWith(URL(string: tempImage), placeholderImage:nil)
        
        let titleWidth = containerView.frame.size.width - horizontalSpaceX*3 - productImageView.frame.size.width
        let titleHeight = (containerView.frame.size.height - verticalSpaceY*2)*0.6
        
        let productTitle = UILabel(frame: CGRect(x: horizontalSpaceX + productImageView.frame.size.width + horizontalSpaceX, y: verticalSpaceY, width: titleWidth, height: titleHeight))
        productTitle.text = "\(productName ?? "")"
        containerView.addSubview(productTitle)
        productTitle.font = UIFont(name: robotoBold, size: 15*factx)
        productTitle.backgroundColor = .clear
        productTitle.numberOfLines = 2
        
        let priceHeight = (containerView.frame.size.height - verticalSpaceY*2 - titleHeight)

        let priceLabel = UILabel(frame: CGRect(x: productTitle.frame.origin.x, y:productTitle.frame.size.height+verticalSpaceY , width: productTitle.frame.size.width/2, height: priceHeight))
        priceLabel.backgroundColor = .clear
        priceLabel.text = "£ \(productPrice ?? 0)"
        priceLabel.font = UIFont(name: robotoBold, size: 15*factx)
        priceLabel.textColor = .lightText
        priceLabel.textAlignment = .center
        containerView.addSubview(priceLabel)
        
        productTitle.sizeToFit() // DONT MOVE FROM HERE
        
        let buttonContainerView = UIView(frame: CGRect(x: priceLabel.frame.origin.x + priceLabel.frame.size.width, y: priceLabel.frame.origin.y, width: priceLabel.frame.size.width, height: priceLabel.frame.size.height))
        buttonContainerView.backgroundColor = .clear
        containerView.addSubview(buttonContainerView)
        
        let minusBtn = UIButton(frame: CGRect(x: 5*factx, y: 0, width: buttonContainerView.frame.size.height, height: buttonContainerView.frame.size.height))
        minusBtn.layer.cornerRadius = buttonContainerView.frame.size.height/2
        minusBtn.layer.borderColor = UIColor.white.cgColor
        minusBtn.layer.borderWidth = 2.0
        minusBtn.titleLabel?.font = UIFont(name: robotoBold, size: 18*factx)
        buttonContainerView.addSubview(minusBtn)
        minusBtn.setTitle("-", for: .normal)
        
        let numberOfProductLabel = UILabel(frame: CGRect(x: minusBtn.frame.origin.x + minusBtn.frame.size.width, y: 0, width: buttonContainerView.frame.size.width/3, height: buttonContainerView.frame.size.height))
        buttonContainerView.addSubview(numberOfProductLabel)
        numberOfProductLabel.text = "100"
        numberOfProductLabel.textAlignment = .center
        
        
        let plusBtn = UIButton(frame: CGRect(x: numberOfProductLabel.frame.origin.x + numberOfProductLabel.frame.size.width, y: 0, width: buttonContainerView.frame.size.height, height: buttonContainerView.frame.size.height))
        plusBtn.layer.cornerRadius = buttonContainerView.frame.size.height/2
        plusBtn.layer.borderColor = UIColor.white.cgColor
        plusBtn.layer.borderWidth = 2.0
        plusBtn.titleLabel?.font = UIFont(name: robotoBold, size: 18*factx)
        buttonContainerView.addSubview(plusBtn)
        plusBtn.setTitle("+", for: .normal)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100*factx
    }
    
    @IBOutlet weak var calculationView: UIView!
    @IBOutlet weak var cartTableView: UITableView!
    
     
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar(largeTitleColor: .white, backgoundColor: UIColor(rgb: 0xFF9300), tintColor: UIColor(rgb: appDefaultColor), title: "Cart", preferredLargeTitle: true)

        let checkoutBtn = UIButton(type: .system)
        checkoutBtn.setTitle("Checkout", for: .normal)
        checkoutBtn.titleLabel?.font = UIFont(name: robotoBold, size: 15*factx)
        checkoutBtn.tintColor = .white
        checkoutBtn.backgroundColor = .clear
        checkoutBtn.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        checkoutBtn.addTarget(self, action: #selector(checkOutTapped), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: checkoutBtn)
        
        // Do any additional setup after loading the view.
        cartTableView.tableFooterView = UIView()
        cartTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    override func viewWillAppear(_ animated: Bool) {
        makeUI()
    }
    func makeUI() {
        
        self.tabBarController?.viewControllers?[1].tabBarItem.badgeValue = nil
        
        let countedSet = NSCountedSet(array: AppManager.sharedInstance().cartDataArr)
            for value in countedSet {
                AppManager.sharedInstance().cartProductDataArr.append(value as! [String : Any])
                AppManager.sharedInstance().cartProductCountArr.append(countedSet.count(for: value))
            }
        print(AppManager.sharedInstance().cartProductDataArr)
        print(AppManager.sharedInstance().cartProductCountArr)
        cartTableView.reloadData()
    }
    @objc func checkOutTapped(sender:UIButton) {
        print("asdfa")

    }

}
