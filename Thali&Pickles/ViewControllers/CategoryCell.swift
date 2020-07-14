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
        cartBtn.backgroundColor = UIColor(rgb: appDefaultColor)


        // border
        cartBtn.layer.borderWidth = 0.3
        cartBtn.layer.borderColor = UIColor.white.cgColor

        // shadow
        cartBtn.layer.shadowColor = UIColor.black.cgColor
        cartBtn.layer.shadowOffset = CGSize(width: 0, height: 0)
        cartBtn.layer.shadowOpacity = 0.7
        cartBtn.layer.shadowRadius = 0.7
        
        infoBtn.tintColor = UIColor(rgb: appDefaultColor)
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
