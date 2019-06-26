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
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtOccupation: UITextField!
    @IBOutlet weak var txtContactNumber: UITextField!
    @IBOutlet weak var txtFirstName: UITextField!
    var style = ToastStyle()
    
    var singleTon = SingleTon.shared

    override func viewDidLoad(){
        super.viewDidLoad()
        setLayout()
    }
    
    func setLayout(){
        applyRoundButtonCorner(button: btnLogin)
        hideKeyboardWhenTappedAround()
        style.backgroundColor = .white
        style.messageColor = .black
    }
  
    @IBAction func backClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
        navigateToLogin()
    }
    
    @IBAction func registerClicked(_ sender: Any) {
        self.view.endEditing(true)
        
        if txtFirstName.text?.count == 0 || txtLastName.text?.count == 0 || txtContactNumber.text?.count == 0 || txtOccupation.text?.count == 0 || txtEmail.text?.count == 0 || txtPassword.text?.count == 0 {
            self.view.makeToast("Please enter all fields.", duration: 3.0, position: .bottom, style: style)
            return
        }
        
        if(!isValidText(testStr: txtFirstName.text!)){
            self.view.makeToast("Please enter valid first name.", duration: 3.0, position: .bottom, style: style)
            return
        }
        
        if(!isValidText(testStr: txtLastName.text!)){
            self.view.makeToast("Please enter valid last name.", duration: 3.0, position: .bottom, style: style)
            return
        }
        
        if(!isValidPhone(testStr: txtContactNumber.text!)){
            self.view.makeToast("Please enter valid contact number.", duration: 3.0, position: .bottom, style: style)
            return
        }
        
        if(!isValidText(testStr: txtOccupation.text!)){
            self.view.makeToast("Please enter valid occupation.", duration: 3.0, position: .bottom, style: style)
            return
        }
        
        let isValidPassword = txtPassword.text!.count
        if isValidPassword <= 6 {
            self.view.makeToast("Please enter valid password.")
            return
        }
        
        if(!isValidEmail(testStr: txtEmail.text!)){
            self.view.makeToast("Email format: user@mail.com", duration: 3.0, position: .bottom, style: style)
            return
        }
        
        let UUID = UIDevice.current.identifierForVendor!.uuidString
        let memberDetails: [String: Any] = ["firstname": self.txtFirstName.text!, "lastname": self.txtLastName.text!, "contact": self.txtContactNumber.text!, "occupation": self.txtOccupation.text!, "email": self.txtEmail.text!, "password": self.txtPassword.text!, "username": self.txtEmail.text!, "deviceid": "\(UUID)", "emailverified": false, "pictureurl": "", "datecreated": "", "realm": "", "statuscode":0]
        
        let parameters: [String: Any] = ["member": memberDetails]
        APIHelper().post(apiUrl: GlobalConstants.APIUrls.memberRegister, parameters: parameters as [String : AnyObject]) { (response) in
            
            print("RegisterResponse : ", response)
            
            if response["data"]["member"]["statusCode"].int == 422 {
                if response["data"]["member"]["details"]["messages"]["email"][0].string != nil {
                    let message = response["data"]["member"]["details"]["messages"]["email"][0].string
                    self.view.makeToast(message, duration: 3.0, position: .bottom, style: self.style)
                    return
                }
                else{
                    self.view.makeToast("User already exists", duration: 3.0, position: .bottom, style: self.style)
                    return
                }
            }
            else if response["data"]["member"]["statusCode"].int == 500 {
                self.view.makeToast("Oops! Something went wrong!", duration: 3.0, position: .bottom, style: self.style)
                return
            }
            else if response["data"]["member"]["statusCode"].int == 400 {
                self.view.makeToast("Oops! Something went wrong!", duration: 3.0, position: .bottom, style: self.style)
                return
            }
            
            if response["data"]["member"]["status"].string == "SUCCESS" {
                let stripeCustomerTokenId = response["data"]["member"]["stripecustomertokenid"].string
                
                self.singleTon.userId = response["data"]["member"]["id"].string!

               // DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Payment", bundle:nil)
                    let paymentViewController = storyBoard.instantiateViewController(withIdentifier: "PaymentViewController") as! PaymentViewController
                    paymentViewController.stripeCustomerTokenId = stripeCustomerTokenId
                    self.navigationController?.pushViewController(paymentViewController, animated: true)
              //  })
            }
            
        }
        
        
    }
    
 
}
extension UIViewController
{
    func isValidPhone(testStr:String) -> Bool {
        let phoneRegex = "^[0-9+]{0,1}+[0-9]{5,16}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: testStr)
    }
}
