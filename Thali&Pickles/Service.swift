//
//  Service.swift
//  Thali&Pickles
//
//  Created by Emon on 25/11/19.
//  Copyright © 2019 Emon. All rights reserved.
//

import UIKit
class Service: NSObject {
    
    static let _singletonInstance = Service()
    private override init() {
        //This prevents others from using the default '()' initializer for this class.
    }
    
    @objc public class func sharedInstance() -> Service {
        return Service._singletonInstance
    }

    func getAllGetRequest(requestURL url: String, onSuccess success: @escaping (_ JSONArray: Any) -> Void, onFailure failure: @escaping (_ error: String?) -> Void) {
    
       guard let url = URL(string: url) else {
           return
       }
       var request = URLRequest(url: url)
       request.httpMethod = "GET"
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = [
            "Accept" : "application/json",
            "Content-Type" : "application/x-www-form-urlencoded",
            
        ]
        let session = URLSession(configuration: config)


       let task = session.dataTask(with: request, completionHandler: {(data, response, error) -> Void in
           if(error != nil) {
            failure(error.debugDescription)
               return
           } else {
               let httpResponse = response as? HTTPURLResponse
               do{
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
                   if(httpResponse?.statusCode == 200){
                    success(json!)
                   }else{
                    failure(error.debugDescription)
                   }
               } catch {
                   failure("Server Error")
               }
               
           }
       })
       
       task.resume()
    }
    
    /*
     [
       [
         "name": "checkout",
         "value": "1"
       ],
       [
         "name": "item_id",
         "value": ""
       ],
       [
         "name": "order_type",
         "value": ""
       ],
       [
         "name": "item_count",
         "value": "[1,2,3,4,1]"
       ],
       [
         "name": "order_discount",
         "value": "12.0"
       ]
     ]
     */
    struct checkOut: Codable {
        var checkout: Int
        var item_id: [Double]
        var order_type: Int
        var item_count: [Double]
        var order_discount: Double

    }
    func getAllPostRequest(requestForParam param: [String:Any], onSuccess success: @escaping (_ JSONArray: [String:Any]) -> Void, onFailure failure: @escaping (_ error: String?) -> Void) {
        let url = URL(string: "https://www.indianroti.co.uk/new-beta/app-order")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        let _: [String: Any] = param
        
        let checkOutData = checkOut(checkout: param["checkout"] as! Int, item_id: param["item_id"] as! [Double], order_type: param["order_type"] as! Int, item_count: param["item_count"] as! [Double], order_discount: param["order_discount"] as! Double)
        print(checkOutData)
        var jsonData: Data

        do {
            jsonData = try JSONEncoder().encode(checkOutData)
        } catch _ {
            jsonData = param.percentEscaped().data(using: .utf8)!
        }
        request.httpBody = jsonData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                let response = response as? HTTPURLResponse,
                error == nil else { // check for fundamental networking error
                print("error", error ?? "Unknown error")
                failure(error.debugDescription)
                return
            }

            guard (200 ... 299) ~= response.statusCode else {// check for http errors
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                failure("Server Error")
                return
            }

            
            let httpResponse = response as HTTPURLResponse
            do{
                print(httpResponse)
                let str = String(decoding: data, as: UTF8.self)
                print(str)

                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                if(httpResponse.statusCode == 200){
                    success(json!)
                }else{
                    failure(error.debugDescription)
                }
            } catch {
                failure("Server Error")
            }
        }

        task.resume()
    }
}
extension Dictionary {
    func percentEscaped() -> String {
        return map { (key, value) in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}
