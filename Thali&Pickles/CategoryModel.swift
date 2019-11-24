//
//  CategoryModel.swift
//  Thali&Pickles
//
//  Created by Emon on 25/11/19.
//  Copyright © 2019 Emon. All rights reserved.
//

import UIKit

class CategoryModel : Codable {
    var categoryId : Int64?
    var categoryTitle : String?
    var categoryImage : String?

    
    init() {
        categoryId = 0
        categoryTitle = ""
        categoryImage = ""
        
    }
    
    enum CodingKeys: String, CodingKey {
        case category_Id = "id"
        case category_Title = "title"
        case category_Image = "image"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        categoryId = try values.decodeIfPresent(Int64.self, forKey: .category_Id)
        categoryTitle = try values.decodeIfPresent(String.self, forKey: .category_Title)
        categoryImage = try values.decodeIfPresent(String.self, forKey: .category_Image)
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(categoryId, forKey: .category_Id)
        try container.encode(categoryTitle, forKey: .category_Title)
        try container.encode(categoryImage, forKey: .category_Image)
    }
}

