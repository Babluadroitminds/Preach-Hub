//
//  RegistrationVC.swift
//  Preach Hub
//
//  Created by Sajeev Sasidharan on 16/05/19.
//  Copyright © 2019 AdroitMinds. All rights reserved.
//

import UIKit

class RegistrationVC: UIViewController{
    @IBOutlet weak var btnRegister: UIButton!
    
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    
    @IBOutlet weak var txtOccupation: UITextField!
    @IBOutlet weak var txtContactNumber: UITextField!
    @IBOutlet weak var txtFirstName: UITextField!
    override func viewDidLoad(){
        super.viewDidLoad()
        setLayout()
    }
    
    func setLayout(){
        hideKeyboardWhenTappedAround()
    }
  
    @IBAction func backClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func registerClicked(_ sender: Any) {
        if txtFirstName.text?.count == 0 || txtLastName.text?.count == 0 || txtContactNumber.text?.count == 0 || txtOccupation.text?.count == 0 || txtEmail.text?.count == 0 || txtPassword.text?.count == 0 {
            self.view.makeToast("Please enter all fields.", duration: 3.0, position: .bottom)
            return
        }
        
        if(!isValidEmail(testStr: "txtEmail.text")){
              self.view.makeToast("Email format: user@mail.com", duration: 3.0, position: .bottom)
            return
        }
        
        let UUID = UIDevice.current.identifierForVendor!.uuidString
        let parameters: [String: String] = ["firstname": self.txtFirstName.text!, "lastname": self.txtLastName.text!, "mobileno": self.txtContactNumber.text!, "occupation": self.txtOccupation.text!, "email": txtEmail.text!, "password": self.txtPassword.text!, "username": self.txtEmail.text!, "deviceid": "\(UUID)"]
        APIHelper().postUserRequest(apiUrl: GlobalConstants.APIUrls.memberRegister, parameters: parameters as [String : AnyObject]) { (response) in
            
            if response == 200 {
                self.view.makeToast("Successfully Registered with PreachHub!", duration: 3.0, position: .bottom)
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
                    
                })
            }
            else if response == 422 {
                self.view.makeToast("User already exists", duration: 3.0, position: .bottom)
            }
            else if response == 500 {
                self.view.makeToast("Oops! Something went wrong!", duration: 3.0, position: .bottom)
            }
        }
    }
    
    
}
