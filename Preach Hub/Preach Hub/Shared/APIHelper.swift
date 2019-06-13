//
//  APIHelper.swift
//  Preach Hub
//
//  Created by Sajeev S L on 16/05/19.
//  Copyright © 2019 AdroitMinds. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import SVProgressHUD
import Crashlytics

class APIHelper: NSObject {
    
    func get(apiUrl:String, parameters:[String:AnyObject], callback:@escaping (JSON) -> Void){
        sendRequest(apiUrl: apiUrl, method: .get, parameters: parameters, showBusyIndicator: true, callback: callback)
    }
    
    func post(apiUrl:String, parameters:[String:AnyObject], callback:@escaping (JSON) -> Void){
        sendRequest(apiUrl: apiUrl, method: .post, parameters: parameters, showBusyIndicator: true, callback: callback)
    }
    
    func patch(apiUrl:String, parameters:[String:AnyObject], callback:@escaping (JSON) -> Void){
        sendRequest(apiUrl: apiUrl, method: .patch, parameters: parameters, showBusyIndicator: true, callback: callback)
    }
    
    func delete(apiUrl:String, parameters:[String:AnyObject], callback:@escaping (JSON) -> Void){
        sendRequest(apiUrl: apiUrl, method: .delete, parameters: parameters, showBusyIndicator: true, callback: callback)
    }
    
    func deleteBackground(apiUrl:String, parameters:[String:AnyObject], callback:@escaping (JSON) -> Void){
        sendRequest(apiUrl: apiUrl, method: .delete, parameters: parameters, showBusyIndicator: false, callback: callback)
    }
    
    func postBackground(apiUrl:String, parameters:[String:AnyObject], callback:@escaping (JSON) -> Void){
        sendRequest(apiUrl: apiUrl, method: .post, parameters: parameters, showBusyIndicator: false, callback: callback)
    }
    
    func putBackground(apiUrl:String, parameters:[String:AnyObject], callback:@escaping (JSON) -> Void){
        sendRequest(apiUrl: apiUrl, method: .put, parameters: parameters, showBusyIndicator: false, callback: callback)
    }
    
    func postUserRequest(apiUrl:String, parameters:[String:AnyObject], callback:@escaping (Int) -> Void){
        sendUserRequest(apiUrl: apiUrl, method: .post, parameters: parameters, showBusyIndicator: true, callback: callback)
    }
    
    func sendRequest(apiUrl: String, method: HTTPMethod, parameters: [String:AnyObject], showBusyIndicator: Bool, callback: @escaping (JSON) -> Void){
        
        if(!NetworkReachabilityManager()!.isReachable){
            if(showBusyIndicator){
                self.alertOnError("Please check your internet connectivity and try again.")
            }
            
            return
        }
        
        var httpHeader: HTTPHeaders = HTTPHeaders()
        
        // Get Token for Admin/User
        let accessToken = UserDefaults.standard.string(forKey: "access_token")
        
        if(accessToken != nil){
            
            httpHeader["Authorization"] = "bearer" + " " + accessToken!
        }
        var fullUrl = ""
        if apiUrl.contains("api.stripe.com"){
            fullUrl = apiUrl
            httpHeader["Authorization"] = "Bearer sk_test_vzXTFAJH3fOKhon5we02Dozo00vpLeAt20"
        }
        else if apiUrl.contains("https://www.jmtbiz"){
             fullUrl = apiUrl
        }
        else if apiUrl.contains("http://jmtbiz")
        {
            fullUrl = apiUrl
        }
        else {
            fullUrl = GlobalConstants.APIUrls.apiBaseUrl + apiUrl
            fullUrl = fullUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        }
        
        if(showBusyIndicator){
                NotificationsHelper.showBusyIndicator(message: "Please Wait")
        }
        
        Alamofire.request(fullUrl, method: method, parameters: parameters,headers: httpHeader).responseJSON { (response) in
            
          if(showBusyIndicator){
                    NotificationsHelper.hideBusyIndicator()
          }
        
          switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    callback(json)
                case .failure(let error):
                    Crashlytics.sharedInstance().recordError(error)
                    
                    if(showBusyIndicator){
                        
                        self.alertOnError("An error occured while processing your request, Please try again.")
                    }
                }
        }
    }
    
    
    func sendUserRequest(apiUrl: String, method: HTTPMethod, parameters: [String:AnyObject], showBusyIndicator: Bool, callback: @escaping (Int) -> Void){
        
        if(!NetworkReachabilityManager()!.isReachable){
            if(showBusyIndicator){
                NotificationsHelper.hideBusyIndicator()
            }
            return
        }
        
        let httpHeader: HTTPHeaders = HTTPHeaders()
        
        let fullUrl = GlobalConstants.APIUrls.apiBaseUrl + apiUrl
        
        if(showBusyIndicator){
            NotificationsHelper.showBusyIndicator(message: "Please Wait")
        }
        
        Alamofire.request(fullUrl, method: method, parameters: parameters, encoding:
            JSONEncoding.default,  headers: httpHeader).responseJSON { (response) in
                if(showBusyIndicator){
                    NotificationsHelper.hideBusyIndicator()
                }
                callback((response.response?.statusCode)!)
        }
    }
    
    func alertOnError(_ errorMsg: String){
        var topVC = UIApplication.shared.keyWindow?.rootViewController
        while((topVC!.presentedViewController) != nil){
            topVC = topVC!.presentedViewController
        }
        let alert = UIAlertController(title: "Alert", message: errorMsg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {action in
        }
        ))
        topVC?.present(alert, animated: true, completion: nil)
    }
    
}
