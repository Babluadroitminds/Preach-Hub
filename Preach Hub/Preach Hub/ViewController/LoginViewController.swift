//
//  LoginVC.swift
//  Preach Hub
//
//  Created by Sajeev Sasidharan on 16/05/19.
//  Copyright © 2019 AdroitMinds. All rights reserved.
//

import UIKit
import SwiftyJSON
import Toast_Swift

class LoginViewController: UIViewController{
    
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var viewUsername: UIView!
    var style = ToastStyle()
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad(){
        super.viewDidLoad()
        setLayout()
    }
    
    func setLayout(){
        hideKeyboardWhenTappedAround()
        applyRoundViewCorner(view: viewPassword)
        applyRoundViewCorner(view: viewUsername)
        applyRoundButtonCorner(button: btnRegister)
        style.backgroundColor = .white
        style.messageColor = .black
    }
    
    @IBAction func btnPasswordVisibilityClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected == true{
            txtPassword.isSecureTextEntry = false
        }
        else{
            txtPassword.isSecureTextEntry = true
        }
    }
    
    @IBAction func loginClicked(_ sender: Any) {
        if txtUsername.text?.count == 0 || txtPassword.text?.count == 0{
            self.view.makeToast("Please enter all fields.", duration: 3.0, position: .bottom, style: style)
            return
        }
        
        let parameters: [String: String] = ["username": self.txtUsername.text!, "password": self.txtPassword.text!]
        APIHelper().post(apiUrl: GlobalConstants.APIUrls.memberLogin, parameters: parameters as [String : AnyObject]) { (response) in
                        
            if response["error"]["statusCode"].int == 401 {
                self.view.makeToast("Wrong Email or Password", duration: 3.0, position: .bottom, style: self.style)
                return
            }
            else if response["error"]["statusCode"].int == 500 {
                self.view.makeToast("Oops! Something went wrong!", duration: 3.0, position: .bottom, style: self.style)
                return
            }
            
            if response["data"] != JSON.null {
                self.userDefaults.set(true, forKey: "Is_Logged_In")
                let memberId = response["data"]["userId"].string
                self.userDefaults.set(memberId, forKey: "memberId")
                self.getDetails(memberId: memberId!)
            }
        }
    }
    
    func getDetails(memberId: String){
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let parameters: [String: String] = [:]
        APIHelper().get(apiUrl: String.init(format: GlobalConstants.APIUrls.memberDetails,memberId), parameters: parameters as [String : AnyObject]) { (response) in
            
            print("responseLogin : ", response)

            if response["data"] != JSON.null  {
                if response["data"]["emailVerified"].boolValue{
                    let profileDetails : [String : String] = ["FirstName": response["data"]["firstname"] != JSON.null ? response["data"]["firstname"].string! : "", "LastName": response["data"]["lastname"] != JSON.null ? response["data"]["lastname"].string! : "", "ContactNumber": response["data"]["contact"] != JSON.null ? response["data"]["contact"].string! : "", "Occupation": response["data"]["occupation"] != JSON.null ? response["data"]["occupation"].string! : "", "Email": response["data"]["email"] != JSON.null ? response["data"]["email"].string! : "", "Address": response["data"]["address"] != JSON.null ? response["data"]["address"].string! : ""]
                    
                    let productData = NSKeyedArchiver.archivedData(withRootObject: profileDetails)
                    self.userDefaults.set(productData, forKey: "ProfileDetails")
                    self.userDefaults.synchronize()
                    
                    let firstName = response["data"]["firstname"] != JSON.null ? response["data"]["firstname"].string : ""
                    let lastName = response["data"]["lastname"] != JSON.null ? response["data"]["lastname"].string : ""
                    let memberName = firstName! + " " + lastName!
                    self.userDefaults.set(response["data"]["stripecustomertokenid"].string, forKey: "stripeCustomerTokenId")
                    self.userDefaults.set(memberName, forKey: "memberName")
                    appDelegate?.registerDevice()
                    self.view.makeToast("You are now logged in", duration: 3.0, position: .bottom, style: self.style)
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
                        self.navigateToHomeScreenPage()
                    })
                }
                else{
                   self.view.makeToast("Please verify your email", duration: 3.0, position: .bottom, style: self.style)
                   return
                }
            }
        }
    }
}
