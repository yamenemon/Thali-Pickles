//
//  CategoryCell.swift
//  Thali&Pickles
//
//  Created by Emon on 11/25/19.
//  Copyright © 2019 Emon. All rights reserved.
//

import UIKit

@objc public protocol addToCartDelegate: NSObjectProtocol {

    func addToCartBtnActionDelegate(sender:UIButton)
    func infoBtnActionDelegate(sender:UIButton)
}

class CategoryCell: UITableViewCell {

    @objc var delegate: addToCartDelegate?

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var categoryPrice: UILabel!
    @IBOutlet weak var cartBtn: UIButton!
    
    @IBOutlet weak var infoBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        containerView.layer.cornerRadius = 2.0
//        containerView.layer.borderWidth = 1.0
//        containerView.layer.borderColor = UIColor.clear.cgColor
//        containerView.layer.masksToBounds = true
//
//        containerView.layer.backgroundColor = UIColor.white.cgColor
//        containerView.layer.shadowColor = UIColor.gray.cgColor
//        containerView.layer.shadowOffset = CGSize(width: 0, height: 0)//CGSizeMake(0, 2.0);
//        containerView.layer.shadowRadius = 1.0
//        containerView.layer.shadowOpacity = 0.4
//        containerView.layer.masksToBounds = false
//        containerView.layer.shadowPath = UIBezierPath(roundedRect:containerView.bounds, cornerRadius:containerView.layer.cornerRadius).cgPath
        
        // corner radius
        containerView.layer.cornerRadius = 5

        // border
        containerView.layer.borderWidth = 0.3
        containerView.layer.borderColor = UIColor.gray.cgColor

        // shadow
        containerView.layer.shadowColor = UIColor.lightGray.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        containerView.layer.shadowOpacity = 0.7
        containerView.layer.shadowRadius = 0.7
        
        
        // corner radius
        cartBtn.layer.cornerRadius = 5

        // border
        cartBtn.layer.borderWidth = 0.3
        cartBtn.layer.borderColor = UIColor.white.cgColor

        // shadow
        cartBtn.layer.shadowColor = UIColor.black.cgColor
        cartBtn.layer.shadowOffset = CGSize(width: 0, height: 0)
        cartBtn.layer.shadowOpacity = 0.7
        cartBtn.layer.shadowRadius = 0.7
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func addToCartBtnAction(_ sender: Any) {
        self.delegate?.addToCartBtnActionDelegate(sender: sender as! UIButton)
    }
    @IBAction func infoBtnAction(_ sender: Any) {
        self.delegate?.infoBtnActionDelegate(sender: sender as! UIButton)

    }
}
