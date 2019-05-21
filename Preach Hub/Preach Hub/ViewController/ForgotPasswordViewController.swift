//
//  ForgotPasswordViewController.swift
//  Preach Hub
//
//  Created by Sajeev S L on 21/05/19.
//  Copyright © 2019 AdroitMinds. All rights reserved.
//

import UIKit
import Toast_Swift

class ForgotPasswordViewController: UIViewController {
    @IBOutlet weak var txtEmail: UITextField!
    var style = ToastStyle()
    
    override func viewDidLoad() {
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

    @IBAction func sendClicked(_ sender: Any) {
        if txtEmail.text?.count == 0 {
            self.view.makeToast("Please enter email.", duration: 3.0, position: .bottom, style: style)
            return
        }
        
        if(!isValidEmail(testStr: txtEmail.text!)){
            self.view.makeToast("Email format: user@mail.com", duration: 3.0, position: .bottom, style: style)
            return
        }
        
        let parameters: [String: String] = ["email": txtEmail.text!]
        APIHelper().postUserRequest(apiUrl: GlobalConstants.APIUrls.memberReset, parameters: parameters as [String : AnyObject]) { (response) in
            
            if response == 200 {
                self.view.makeToast("Email has been sent to reset password!", duration: 3.0, position: .bottom, style: self.style)
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
                    
                })
            }
            else if response == 404 {
                self.view.makeToast("No account found for this email address", duration: 3.0, position: .bottom, style: self.style)
            }
            else{
                self.view.makeToast("Oops! Something went wrong!", duration: 3.0, position: .bottom, style: self.style)
            }
        }
        
    }
}
