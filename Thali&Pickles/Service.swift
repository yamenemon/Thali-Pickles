//
//  Service.swift
//  Thali&Pickles
//
//  Created by Emon on 25/11/19.
//  Copyright © 2019 Emon. All rights reserved.
//

import UIKit
import SVProgressHUD
class Service: NSObject {
    
    static let _singletonInstance = Service()
    private override init() {
        //This prevents others from using the default '()' initializer for this class.
    }
    
    @objc public class func sharedInstance() -> Service {
        return Service._singletonInstance
    }

    func getAllFoodCategory(requestURL url: String, onSuccess success: @escaping (_ JSONArray: Any) -> Void, onFailure failure: @escaping (_ error: String?) -> Void) {
    
       guard let url = URL(string: url) else {
           return
       }
       var message:String = "";
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
               message = "Error Occured"
               failure(message)
               return
           } else {
               let httpResponse = response as? HTTPURLResponse
               do{
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
//                let jsonDecoder = JSONDecoder()
//                let responseModel = try jsonDecoder.decode(CategoryModel.self, from: data!)
                
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
}
