//
//  ProfileDetailsViewController.swift
//  Preach Hub
//
//  Created by Sajeev S L on 27/06/19.
//  Copyright © 2019 AdroitMinds. All rights reserved.
//

import UIKit
import Toast_Swift
import SwiftyJSON

class ProfileDetailsViewController: UIViewController {
    
    @IBOutlet weak var txtContactNumber: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtFirstName: UITextField!
    var style = ToastStyle()
    var profileDetails : [String : String]!
    let userDefaults = UserDefaults.standard
    var churchId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        hideKeyboardWhenTappedAround()
    }
    
    func setLayout(){
        style.backgroundColor = .white
        style.messageColor = .black
        if UserDefaults.standard.value(forKey: "ProfileDetails") as? Data != nil {
            let data = UserDefaults.standard.value(forKey: "ProfileDetails") as? Data
            self.profileDetails = (NSKeyedUnarchiver.unarchiveObject(with: data!)! as? [String : String])!
            self.txtContactNumber.text = self.profileDetails["ContactNumber"]
            self.txtLastName.text = self.profileDetails["LastName"]
            self.txtFirstName.text = self.profileDetails["FirstName"]
        }
        getProfileDetails()
    }
    
    @IBAction func backClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveClicked(_ sender: Any) {
        view.endEditing(true)
        if self.txtFirstName.text?.count == 0 || self.txtLastName.text?.count == 0 || self.txtContactNumber.text?.count == 0{
            self.view.makeToast("Please enter all fields.", duration: 3.0, position: .bottom, style: style)
            return
        }
        
        if(!isValidText(testStr: self.txtFirstName.text!)){
            self.view.makeToast("Please enter valid first name.", duration: 3.0, position: .bottom, style: style)
            return
        }
        
        if(!isValidText(testStr: self.txtLastName.text!)){
            self.view.makeToast("Please enter valid last name.", duration: 3.0, position: .bottom, style: style)
            return
        }
        
        if(!isValidPhone(testStr: self.txtContactNumber.text!)){
            self.view.makeToast("Please enter valid contact number.", duration: 3.0, position: .bottom, style: style)
            return
        }
        
        let memberId = UserDefaults.standard.value(forKey: "memberId") as? String
        let stripeCustomerTokenId = UserDefaults.standard.value(forKey: "stripeCustomerTokenId") as? String
        
        let memberDetails: [String: Any] = ["firstname": self.txtFirstName.text!, "lastname": self.txtLastName.text!, "contact": self.txtContactNumber.text!, "occupation": self.profileDetails["Occupation"]!, "email": self.profileDetails["Email"]!, "address": self.profileDetails["Address"] != nil ? self.profileDetails["Address"]! : "", "username": self.profileDetails["Email"]!, "deviceid": "\(UUID())", "emailverified": true, "pictureurl": "", "realm": "", "status": "SUCCESS", "subscriptionDate": "", "churchid": churchId, "stripecustomerid": stripeCustomerTokenId!, "issubscribed": true, "subscriptionenddate": true, "parentid": "", "id": memberId!]
        
        let parameters: [String: Any] = memberDetails
        APIHelper().patch(apiUrl: String.init(format: GlobalConstants.APIUrls.memberDetails, memberId!), parameters: parameters as [String : AnyObject]) { (response) in
            
            if response["data"].dictionary != nil  {
                self.view.makeToast("Profile updated successfully!", duration: 3.0, position: .bottom, title: nil, image: nil, style: self.style , completion: nil)
                self.getProfileDetails()
            }
        }
    }
    
    
    func getProfileDetails(){
        let memberId = UserDefaults.standard.value(forKey: "memberId") as? String
        let parameters: [String: String] = [:]
        APIHelper().getBackground(apiUrl: String.init(format: GlobalConstants.APIUrls.memberDetails,memberId!), parameters: parameters as [String : AnyObject]) { (response) in
            
            print("responseLogin : ", response)
            
            if response["data"] != JSON.null  {
                
                let profileDetails : [String : String] = ["FirstName": response["data"]["firstname"] != JSON.null ? response["data"]["firstname"].string! : "", "LastName": response["data"]["lastname"] != JSON.null ? response["data"]["lastname"].string! : "", "ContactNumber": response["data"]["contact"] != JSON.null ? response["data"]["contact"].string! : "", "Occupation": response["data"]["occupation"] != JSON.null ? response["data"]["occupation"].string! : "", "Email": response["data"]["email"] != JSON.null ? response["data"]["email"].string! : "", "Address": response["data"]["address"] != JSON.null ? response["data"]["address"].string! : ""]
                
                let productData = NSKeyedArchiver.archivedData(withRootObject: profileDetails)
                self.userDefaults.set(productData, forKey: "ProfileDetails")
                self.userDefaults.synchronize()
                if response["data"]["churchid"].string != nil {
                    self.churchId = response["data"]["churchid"].string!
                }
                let firstName = response["data"]["firstname"] != JSON.null ? response["data"]["firstname"].string : ""
                let lastName = response["data"]["lastname"] != JSON.null ? response["data"]["lastname"].string : ""
                let memberName = firstName! + " " + lastName!
                self.userDefaults.set(response["data"]["stripecustomertokenid"].string, forKey: "stripeCustomerTokenId")
                self.userDefaults.set(memberName, forKey: "memberName")
            }
        }
    }
    
    static func storyboardInstance() -> ProfileDetailsViewController? {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "ProfileDetailsViewController") as? ProfileDetailsViewController
    }
}
