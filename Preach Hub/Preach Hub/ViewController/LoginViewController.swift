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
    
    @IBAction func loginClicked(_ sender: Any) {
        if txtUsername.text?.count == 0 || txtPassword.text?.count == 0{
            self.view.makeToast("Please enter all fields.", duration: 3.0, position: .bottom, style: style)
            return
        }
        
        let parameters: [String: String] = ["username": self.txtUsername.text!, "password": self.txtPassword.text!]
        APIHelper().postUserRequest(apiUrl: GlobalConstants.APIUrls.memberLogin, parameters: parameters as [String : AnyObject]) { (response) in
            
            if response == 200 {
                let userDefaults = UserDefaults.standard
                userDefaults.set(true, forKey: "Is_Logged_In")
                
                self.view.makeToast("You are now logged in", duration: 3.0, position: .bottom, style: self.style)
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
                   self.navigateToHomeScreenPage()
                })
            }
            else if response == 401 {
                self.view.makeToast("Wrong Email or Password", duration: 3.0, position: .bottom, style: self.style)
            }
            else if response == 500 {
                self.view.makeToast("Oops! Something went wrong!", duration: 3.0, position: .bottom, style: self.style)
            }
        }
    }
}
