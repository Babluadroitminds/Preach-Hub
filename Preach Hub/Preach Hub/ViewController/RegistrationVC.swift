//
//  RegistrationVC.swift
//  Preach Hub
//
//  Created by Sajeev Sasidharan on 16/05/19.
//  Copyright © 2019 AdroitMinds. All rights reserved.
//

import UIKit
import Toast_Swift

class RegistrationVC: UIViewController{
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtOccupation: UITextField!
    @IBOutlet weak var txtContactNumber: UITextField!
    @IBOutlet weak var txtFirstName: UITextField!
    var style = ToastStyle()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        setLayout()
    }
    
    func setLayout(){
        hideKeyboardWhenTappedAround()
        style.backgroundColor = .white
        style.messageColor = .black
    }
  
    @IBAction func backClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func verifyEmail(completion: @escaping (_ keys: Bool) -> Void) {
        var emailStatus: Bool = false
        let parameters: [String: String] = [:]
        
        let dict = ["where": [ "email": "\(txtEmail.text!)"]]
        
        if let json = try? JSONSerialization.data(withJSONObject: dict, options: []) {
            if let content = String(data: json, encoding: String.Encoding.utf8) {
               APIHelper().get(apiUrl: String.init(format: GlobalConstants.APIUrls.verifyEmail,content), parameters: parameters as [String : AnyObject]) { (response) in
                    
                    if(response["data"].dictionary != nil) {
                        emailStatus = false
                    }
                    else{
                        emailStatus = true
                    }
                    if emailStatus == false {
                        self.view!.makeToast("Email already exists.", duration: 3.0, position: .bottom, style: self.style)
                    }
                    completion(emailStatus)
                }
             
            }
        }

    }
    
    @IBAction func registerClicked(_ sender: Any) {
        
        if txtFirstName.text?.count == 0 || txtLastName.text?.count == 0 || txtContactNumber.text?.count == 0 || txtOccupation.text?.count == 0 || txtEmail.text?.count == 0 || txtPassword.text?.count == 0 {
            self.view.makeToast("Please enter all fields.", duration: 3.0, position: .bottom, style: style)
            return
        }
        
        if(!isValidEmail(testStr: txtEmail.text!)){
              self.view.makeToast("Email format: user@mail.com", duration: 3.0, position: .bottom, style: style)
            return
        }
        
        let isVerifiedEmail = self.verifyEmail(completion: { (keys) in
            if keys ==  false {
                return;
            }
            else {
                let UUID = UIDevice.current.identifierForVendor!.uuidString
                let parameters: [String: String] = ["firstname": self.txtFirstName.text!, "lastname": self.txtLastName.text!, "mobileno": self.txtContactNumber.text!, "occupation": self.txtOccupation.text!, "email": self.txtEmail.text!, "password": self.txtPassword.text!, "username": self.txtEmail.text!, "deviceid": "\(UUID)"]
                APIHelper().postUserRequest(apiUrl: GlobalConstants.APIUrls.memberRegister, parameters: parameters as [String : AnyObject]) { (response) in
                    
                    if response == 200 {
                        self.view.makeToast("Successfully Registered with PreachHub!", duration: 3.0, position: .bottom, style: self.style)
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
                            self.navigateToPaymentPage()
                        })
                    }
                    else if response == 422 {
                        self.view.makeToast("User already exists", duration: 3.0, position: .bottom, style: self.style)
                    }
                    else if response == 500 {
                        self.view.makeToast("Oops! Something went wrong!", duration: 3.0, position: .bottom, style: self.style)
                    }
                    
                }
            }
        })
    }
    
    
}
