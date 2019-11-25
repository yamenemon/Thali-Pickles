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
}

class CategoryCell: UITableViewCell {

    @objc var delegate: addToCartDelegate?

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var categoryPrice: UILabel!
    @IBOutlet weak var categoryDescription: UILabel!
    @IBOutlet weak var cartBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func addToCartBtnAction(_ sender: Any) {
        self.delegate?.addToCartBtnActionDelegate(sender: sender as! UIButton)
    }
}
