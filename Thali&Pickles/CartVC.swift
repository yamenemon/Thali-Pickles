//
//  CartVC.swift
//  Thali&Pickles
//
//  Created by Emon on 26/11/19.
//  Copyright © 2019 Emon. All rights reserved.
//

import UIKit
import Toast_Swift

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
        containerView.backgroundColor = UIColor(rgb: 0xEBA54B)
        
        let contentData = AppManager.sharedInstance().cartProductDataArr[indexPath.row]
        let contentAmount = AppManager.sharedInstance().cartProductCountArr[indexPath.row]
        
        let productName = contentData["sub_category_title"]
        let productInfo = contentData["sub_category_products"] as! [String:Any]
        var perProductPrice = 0.0
        if let productPrice = (productInfo["product_price"] as? NSString)?.doubleValue {
            perProductPrice = productPrice * contentAmount
        }

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
        productTitle.font = UIFont(name: robotoBold, size: 13*factx)
        productTitle.backgroundColor = .clear
        productTitle.numberOfLines = 2
        
        let priceHeight = (containerView.frame.size.height - verticalSpaceY*2 - titleHeight)

        let priceLabel = UILabel(frame: CGRect(x: productTitle.frame.origin.x, y:productTitle.frame.size.height+verticalSpaceY , width: productTitle.frame.size.width/2, height: priceHeight))
        priceLabel.backgroundColor = .clear
        priceLabel.text = String(format: "£ %.2f", perProductPrice)
        priceLabel.font = UIFont(name: robotoBold, size: 13*factx)
        priceLabel.textColor = .lightText
        priceLabel.textAlignment = .center
        containerView.addSubview(priceLabel)
        
        productTitle.sizeToFit() // DONT MOVE FROM HERE
        
        let buttonContainerView = UIView(frame: CGRect(x: priceLabel.frame.origin.x + priceLabel.frame.size.width, y: priceLabel.frame.origin.y, width: priceLabel.frame.size.width, height: priceLabel.frame.size.height))
        buttonContainerView.backgroundColor = .clear
        containerView.addSubview(buttonContainerView)
        
        let minusBtn = CustomButton()
        minusBtn.frame = CGRect(x: 5*factx, y: 0, width: buttonContainerView.frame.size.height, height: buttonContainerView.frame.size.height)
        minusBtn.layer.cornerRadius = buttonContainerView.frame.size.height/2
        minusBtn.layer.borderColor = UIColor.white.cgColor
        minusBtn.layer.borderWidth = 2.0
        minusBtn.titleLabel?.font = UIFont(name: robotoBold, size: 18*factx)
        buttonContainerView.addSubview(minusBtn)
        minusBtn.indexPath = indexPath.row
        minusBtn.tag = 1
        minusBtn.addTarget(self, action: #selector(plusMinusBtnAction), for: .touchUpInside)
        minusBtn.setTitle("-", for: .normal)
        
        let numberOfProductLabel = UILabel(frame: CGRect(x: minusBtn.frame.origin.x + minusBtn.frame.size.width, y: 0, width: buttonContainerView.frame.size.width/3, height: buttonContainerView.frame.size.height))
        buttonContainerView.addSubview(numberOfProductLabel)
        numberOfProductLabel.text = "\(contentAmount)"
        numberOfProductLabel.textAlignment = .center
        
        
        let plusBtn = CustomButton()
        plusBtn.frame = CGRect(x: numberOfProductLabel.frame.origin.x + numberOfProductLabel.frame.size.width, y: 0, width: buttonContainerView.frame.size.height, height: buttonContainerView.frame.size.height)
        plusBtn.layer.cornerRadius = buttonContainerView.frame.size.height/2
        plusBtn.layer.borderColor = UIColor.white.cgColor
        plusBtn.layer.borderWidth = 2.0
        plusBtn.titleLabel?.font = UIFont(name: robotoBold, size: 18*factx)
        buttonContainerView.addSubview(plusBtn)
        plusBtn.indexPath = indexPath.row
        plusBtn.tag = 2
        plusBtn.addTarget(self, action: #selector(plusMinusBtnAction), for: .touchUpInside)
        plusBtn.setTitle("+", for: .normal)

        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80*factx
    }
    func reloadView() {
        calculateValues()
    }
    @objc func plusMinusBtnAction(sender:CustomButton) {
        var productCountArr = AppManager.sharedInstance().cartProductCountArr
        let currentArrIndex = sender.indexPath!
        if sender.tag == 1 {
            print("Minus Button pressed tag: \(sender.tag) indexPath: \(currentArrIndex)")
            var contentAmount = productCountArr[currentArrIndex]
            
            if contentAmount == 1 {
                self.view.makeToast("Left Swipe for delete the item/s")
                return
            }
            contentAmount = contentAmount - 1
            productCountArr[currentArrIndex] = contentAmount
            AppManager.sharedInstance().cartProductCountArr = productCountArr
            cartTableView.reloadRows(at: [IndexPath(row: currentArrIndex, section: 0)], with: .automatic)
        }
        else if sender.tag == 2 {
            print("Minus Button pressed tag: \(sender.tag) indexPath: \(currentArrIndex)")
            var contentAmount = productCountArr[currentArrIndex]
            contentAmount = contentAmount + 1
            productCountArr[currentArrIndex] = contentAmount
            AppManager.sharedInstance().cartProductCountArr = productCountArr
            cartTableView.reloadRows(at: [IndexPath(row: currentArrIndex, section: 0)], with: .automatic)
        }
        reloadView()
    }
    func calculateValues() {
        let productArr = AppManager.sharedInstance().cartProductDataArr
        let productCountArr = AppManager.sharedInstance().cartProductCountArr
        var priceArr = [Double]()
        for i in 0..<productArr.count {
            let dict = productArr[i]
            let productInfo = dict["sub_category_products"] as! [String:Any]
            if let productPrice = (productInfo["product_price"] as? NSString)?.doubleValue {
                let price = productPrice * productCountArr[i]
                priceArr.append(price)
            }
        }
        let totalPrice = priceArr.reduce(0, +)
        subTotalPrice.text =  String(format: "£ %.2f", totalPrice)
        
        discountPrice.text = "8.00 %"
        
        var val = (totalPrice * 8)/100
        
        discountPrice.text = String(format: "£ %.2f", val)
        val = totalPrice - val
        
        totalPriceLabel.text = String(format: "£ %.2f", val)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
        print("Deleted")
        AppManager.sharedInstance().cartProductDataArr.remove(at: indexPath.row)
        AppManager.sharedInstance().cartProductCountArr.remove(at: indexPath.row)
        if AppManager.sharedInstance().cartProductCountArr.count == 0 {
            AppManager.sharedInstance().cartProductCountArr = [Double]()
        }
        cartTableView.deleteRows(at: [indexPath], with: .automatic)
        reloadView()
      }
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteButton = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
            self.cartTableView.dataSource?.tableView!(self.cartTableView, commit: .delete, forRowAt: indexPath)
            return
        }
        deleteButton.backgroundColor = UIColor.green
        return [deleteButton]
    }
    @IBOutlet weak var calculationView: UIView!
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var subTotalPrice: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var discountPrice: UILabel!
    
    @IBOutlet weak var orderTypeSegment: UISegmentedControl!

    @IBAction func orderTypeSegmentAction(_ sender: Any) {
        
    }
    
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
        self.tabBarController?.viewControllers?[1].tabBarItem.badgeValue = nil
        reloadView()
        cartTableView.reloadData()
    }

    @objc func checkOutTapped(sender:UIButton) {
        print("asdfa")

    }

}
class CustomButton: UIButton {
    var indexPath: Int?
}
