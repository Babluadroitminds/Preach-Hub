//
//  AddBillingAddressViewController.swift
//  Preach Hub
//
//  Created by Sajeev Sasidharan on 28/05/19.
//  Copyright © 2019 AdroitMinds. All rights reserved.
//

import UIKit
import Toast_Swift
import SwiftyJSON
import Stripe
import CoreData

class AddBillingAddressViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate
{
    @IBOutlet weak var countryTxt: UITextField!
    @IBOutlet weak var stateTxt: UITextField!
    @IBOutlet weak var streetLine2Txt: UITextField!
    @IBOutlet weak var txtFldStreet: UITextField!
    @IBOutlet weak var txtFldName: UITextField!
    @IBOutlet weak var txtFldCity: UITextField!
    @IBOutlet weak var txtFldPostalCode: UITextField!
    @IBOutlet weak var txtFldPhoneNumber: UITextField!
    
    var singleTon = SingleTon.shared

    var countryArray: [String] = []
    var stateArray: [String] = []
    
    let countryPickerView =  UIPickerView()
    let statePickerView =  UIPickerView()
    
    var cardNumber = ""
    var expDate = ""
    var cvc = ""
    
    var stripeCustomerTokenId: String?
    var stripeCardToken: String?
    
    var style = ToastStyle()
    var cartList: [[String: String]] = []
    var orderId: String?
    var orderNo: String?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.countryTxt.delegate = self
        self.stateTxt.delegate = self
        self.txtFldName.delegate = self

        countryArray = ["South Africa", "India"]
        stateArray = ["Free State", "Gauteng", "Western Cape", "North West"]
        
        countryTxt.inputView = countryPickerView
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePickerClicked))
        toolbar.setItems([doneButton], animated: false)
        countryTxt.inputAccessoryView = toolbar
        countryPickerView.delegate = self
        
        stateTxt.inputView = statePickerView
        stateTxt.inputAccessoryView = toolbar
        statePickerView.delegate = self
    }
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField == self.countryTxt
        {
            if countryTxt.text == ""
            {
                self.countryTxt.text = self.countryArray[0]
            }
        }
        else if textField == self.stateTxt
        {
            if countryTxt.text == ""
            {
                self.stateTxt.text = self.stateArray[0]
            }
        }
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if pickerView == statePickerView
        {
            return stateArray.count
        }
        else{
            return countryArray.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if pickerView == statePickerView
        {
            return stateArray[row]
        }
        else{
            return countryArray[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if pickerView == statePickerView
        {
            stateTxt.text = stateArray[row]
        }
        else
        {
            countryTxt.text = countryArray[row]
        }
    }
    
    @objc func donePickerClicked()
    {
        self.view.endEditing(true)
    }
    
    @IBAction func backTapped(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnSavePayAction(_ sender: Any)
    {
        if countryTxt.text?.count == 0 || stateTxt.text?.count == 0 || streetLine2Txt.text?.count == 0 || txtFldStreet.text?.count == 0 || txtFldName.text?.count == 0 || txtFldCity.text?.count == 0 || txtFldPostalCode.text?.count == 0 || txtFldPhoneNumber.text?.count == 0
        {
            self.view.makeToast("Please enter all details.", duration: 3.0, position: .bottom)
            return
        }
        if(!isValidPhone(testStr: txtFldPhoneNumber.text!))
        {
            let style = ToastStyle()
            
            self.view.makeToast("Please enter valid phone number.", duration: 3.0, position: .bottom, style: style)
            return
        }
//        let style = ToastStyle()
//
//        self.view.makeToast("Billing address added successfully!", duration: 3.0, position: .bottom, title: nil, image: nil, style: style , completion: { (true) in
//
//            self.singleTon.nameBilling = self.txtFldName.text!
//            self.singleTon.streetBilling = self.txtFldStreet.text!
//            self.singleTon.streetLine2Billing = self.streetLine2Txt.text!
//            self.singleTon.cityBilling = self.txtFldCity.text!
//            self.singleTon.postalCodeBilling = self.txtFldPostalCode.text!
//            self.singleTon.stateBilling = self.stateTxt.text!
//            self.singleTon.countryBilling = self.countryTxt.text!
//            self.singleTon.phoneNumberBilling = self.txtFldPhoneNumber.text!
//
//            self.navigationController?.popViewController(animated: true)
//        })
        //navigateToExistingCardPage()
        NotificationsHelper.showBusyIndicator(message: "")
        
        let cardNumber = self.cardNumber.replacingOccurrences(of: " ", with: "")
        let cardParams = STPCardParams()
        cardParams.number = cardNumber
        cardParams.expMonth = UInt(self.expDate.prefix(2))!
        cardParams.expYear = UInt(self.expDate.suffix(4))!
        cardParams.cvc = self.cvc
        cardParams.name = self.txtFldName.text!
        cardParams.address.line1 = self.txtFldStreet.text!
        cardParams.address.line2 = self.streetLine2Txt.text!
        cardParams.address.state = self.stateTxt.text!
        cardParams.address.country = self.countryTxt.text!
        cardParams.address.city = self.txtFldCity.text!
        cardParams.address.postalCode = self.txtFldPostalCode.text!
        cardParams.address.phone = self.txtFldPhoneNumber.text!
        
        STPAPIClient.shared().createToken(withCard: cardParams) { (token: STPToken?, error: Error?) in
            guard let token = token, error == nil
                else {
                    
                    self.view.makeToast(error?.localizedDescription, duration: 3.0, position: .bottom, style: self.style)
                    NotificationsHelper.hideBusyIndicator()
                    return
            }
            print(token.stripeID)
            
            self.saveToCoreData()
            
            self.stripeCardToken = token.stripeID
            
            NotificationsHelper.hideBusyIndicator()
            
            self.chargeMemberCard()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField == self.txtFldName
        {
            let characterSet = CharacterSet.letters
            
            if string.rangeOfCharacter(from: characterSet.inverted) != nil
            {
                return false
            }
            return true
        }
        return true
    }
    
    func chargeMemberCard(){
        let cartInfo = UserDefaults.standard.object(forKey: "CartDetails") as? NSData
        if let cartInfo = cartInfo {
            cartList = (NSKeyedUnarchiver.unarchiveObject(with: cartInfo as Data) as? [[String: String]])!
        }
        
        let dateFormatter = DateFormatter()
        let date = Date()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat =  "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let orderDate = dateFormatter.string(from: date)
        let shippingAmount: Float = 0
        var sum: Float = 0
        for item in cartList {
            sum = (sum + (Float((item["quantity"]!))! * Float((item["price"])!)!))
        }
        let amount = (sum + shippingAmount)
        let memberId = UserDefaults.standard.string(forKey: "memberId")
        let chargeAmount = (amount * 1000)
        
       // let stripeCustomerTokenId = UserDefaults.standard.string(forKey: "stripeCustomerTokenId")
        let parameters: [String: Any] = ["amount": chargeAmount, "cardToken": stripeCardToken!, "orderno": orderNo!]
        APIHelper().post(apiUrl: GlobalConstants.APIUrls.memberPayByCard, parameters: parameters as [String : AnyObject]) { (response) in
            if response["data"]["transactionresponse"] != JSON.null{
                let parameters: [String: Any] = ["orderno": self.orderNo!, "memberid": memberId!, "paymentmethod": "credit_card", "orderdate": orderDate, "orderstatus": "ordered", "currency": "USD", "currencyvalue": amount, "id": self.orderId!, "parentid": ""]
                APIHelper().patch(apiUrl: String.init(format: GlobalConstants.APIUrls.confirmOrdersById, self.orderId!), parameters: parameters as [String : AnyObject]) { (response) in
                    if response["data"] != JSON.null{
                        self.view.makeToast("Payment successfull!", duration: 3.0, position: .bottom, title: nil, image: nil, style: self.style , completion: { (true) in
                            let productData = NSKeyedArchiver.archivedData(withRootObject: [])
                            UserDefaults.standard.set(productData, forKey: "CartDetails")
                            self.navigateToHomeScreenPage()
                        })
                    }
                    else {
                        self.view.makeToast("Oops! Something went wrong!", duration: 3.0, position: .bottom)
                        return
                    }
                }
            }
            else if response["error"]["message"] != JSON.null {
                self.view.makeToast(response["error"]["message"].string, duration: 3.0, position: .bottom)
            }
            else {
                self.view.makeToast("Oops! Something went wrong!", duration: 3.0, position: .bottom)
                return
            }
        }
    }
    
    func saveToCoreData()
    {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate?.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "CardDetails", in: managedContext!)!
        
        let user = NSManagedObject(entity: entity, insertInto: managedContext!)
        
        let userId = UserDefaults.standard.value(forKey: "memberId") as? String
        
        user.setValue(userId, forKey: "userId")
        
        user.setValue(self.cardNumber, forKey: "cardNumber")
        user.setValue(self.expDate, forKey: "expDate")
        
        user.setValue(self.singleTon.nameBilling, forKey: "nameBilling")
        user.setValue(self.singleTon.streetBilling, forKey: "streetBilling")
        user.setValue(self.singleTon.streetLine2Billing, forKey: "streetLineBilling")
        user.setValue(self.singleTon.cityBilling, forKey: "cityBilling")
        user.setValue(self.singleTon.postalCodeBilling, forKey: "postalCodeBilling")
        user.setValue(self.singleTon.stateBilling, forKey: "stateBilling")
        user.setValue(self.singleTon.countryBilling, forKey: "countryBilling")
        user.setValue(self.singleTon.phoneNumberBilling, forKey: "phoneNoBilling")
        
        do
        {
            try managedContext?.save()
        }
        catch let error as NSError
        {
            print("errorCoreData : ", error.userInfo)
        }
        
        self.singleTon.firstNameShipping = ""
        self.singleTon.lastNameShipping = ""
        self.singleTon.addressShipping = ""
        self.singleTon.streeLine2Shipping = ""
        self.singleTon.emailShipping = ""
        self.singleTon.cityShipping = ""
        self.singleTon.postalCodeShipping = ""
        self.singleTon.stateShipping = ""
        self.singleTon.countryShipping = ""
        self.singleTon.phoneNumberShipping = ""
        
        self.singleTon.nameBilling = ""
        self.singleTon.streetBilling = ""
        self.singleTon.streetLine2Billing = ""
        self.singleTon.cityBilling = ""
        self.singleTon.postalCodeBilling = ""
        self.singleTon.stateBilling = ""
        self.singleTon.countryBilling = ""
        self.singleTon.phoneNumberBilling = ""
    }
}
