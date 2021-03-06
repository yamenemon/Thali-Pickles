//
//  AppManager.swift
//  Thali&Pickles
//
//  Created by Emon on 26/11/19.
//  Copyright © 2019 Emon. All rights reserved.
//

import UIKit
import SystemConfiguration

class AppManager: NSObject {
    static let _singletonInstance = AppManager()
    var cartDataArr = [[String:Any]]()
    var cartProductDataArr = [[String:Any]]()
    var cartProductCountArr = [Double]()
    var checkOutDiscount : Double = 0.0
    var takeOverValue : Int = 0
    var successfullyDelivered : Bool = false
    
    private override init() {
        //This prevents others from using the default '()' initializer for this class.
    }
    
    @objc public class func sharedInstance() -> AppManager {
        return AppManager._singletonInstance
    }
}

public class Reachability {

    class func isConnectedToNetwork() -> Bool {

        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }

        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }

        /* Only Working for WIFI
        let isReachable = flags == .reachable
        let needsConnection = flags == .connectionRequired

        return isReachable && !needsConnection
        */

        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)

        return ret

    }
}
extension UIButton {
    
    func reshapedButton() {
        self.layer.cornerRadius = 8.0
        self.layer.masksToBounds = false
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOpacity = 0.8
        self.layer.shadowRadius = 2
        self.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
    }
}
