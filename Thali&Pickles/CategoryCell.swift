//
//  CategoryCell.swift
//  Thali&Pickles
//
//  Created by Emon on 11/25/19.
//  Copyright © 2019 Emon. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {

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
    
}
