//
//  AppManager.swift
//  Thali&Pickles
//
//  Created by Emon on 26/11/19.
//  Copyright © 2019 Emon. All rights reserved.
//

import UIKit

class AppManager: NSObject {
    static let _singletonInstance = AppManager()
    var cartDataArr = [[String:Any]]()
    var cartProductDataArr = [[String:Any]]()
    var cartProductCountArr = [Int]()

    private override init() {
        //This prevents others from using the default '()' initializer for this class.
    }
    
    @objc public class func sharedInstance() -> AppManager {
        return AppManager._singletonInstance
    }
}
