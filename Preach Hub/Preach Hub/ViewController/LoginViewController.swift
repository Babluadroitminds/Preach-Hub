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
                let userDefaults = UserDefaults.standard
                userDefaults.set(true, forKey: "Is_Logged_In")
                let memberId = response["data"]["userId"].string
                userDefaults.set(memberId, forKey: "memberId")
                
                self.view.makeToast("You are now logged in", duration: 3.0, position: .bottom, style: self.style)
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
                   self.navigateToHomeScreenPage()
                })
            }
          
           
        }
    }
}
