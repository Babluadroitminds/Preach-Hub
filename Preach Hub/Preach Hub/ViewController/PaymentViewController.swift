//
//  PaymentViewController.swift
//  Preach Hub
//
//  Created by Sajeev S L on 21/05/19.
//  Copyright © 2019 AdroitMinds. All rights reserved.
//

import UIKit
import SwiftyJSON
import Stripe
import Toast_Swift
import CoreData

class PaymentViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate
{
    @IBOutlet weak var phoneNumberTxt: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtPostal: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtStreet2: UITextField!
    @IBOutlet weak var txtStreet: UITextField!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtCardName: UITextField!
    @IBOutlet weak var txtExpires: UITextField!
    @IBOutlet weak var txtCVC: UITextField!
    @IBOutlet weak var txtCardNumber: UITextField!
    
    private var previousTextFieldContent: String?
    private var previousSelection: UITextRange?
    
    var stripeCustomerTokenId: String?
    var stripeCardToken: String?
    
    var style = ToastStyle()
    var amount: Int?
    
    var countryArray: [String] = []
    var stateArray: [String] = []
    
    let countryPickerView =  UIPickerView()
    let statePickerView =  UIPickerView()
    
    var singleTon = SingleTon.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        getPlanDetails()
        hideKeyboardWhenTappedAround()
        setPickerLayout()
    }
    
    func setLayout(){
        style.backgroundColor = .white
        style.messageColor = .black
        txtCardNumber.delegate = self
        txtCardNumber.keyboardType = .numberPad
        txtExpires.keyboardType = .numberPad
        txtExpires.delegate = self
        txtCardNumber.addTarget(self, action: #selector(reformatAsCardNumber), for: .editingChanged)
        txtCVC.keyboardType = .numberPad
        txtCVC.delegate = self
        
        countryArray = ["South Africa", "India"]
        stateArray = ["Free State", "Gauteng", "Western Cape", "North West"]
    }
    
    func setPickerLayout(){
        txtCountry.inputView = countryPickerView
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePickerClicked))
        toolbar.setItems([doneButton], animated: false)
        txtCountry.inputAccessoryView = toolbar
        countryPickerView.delegate = self
        
        txtState.inputView = statePickerView
        txtState.inputAccessoryView = toolbar
        statePickerView.delegate = self
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == statePickerView {
            return stateArray.count
        }
        else{
            return countryArray.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == statePickerView {
            return stateArray[row]
        }
        else{
            return countryArray[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == statePickerView {
            txtState.text = stateArray[row]
        }
        else {
            txtCountry.text = countryArray[row]
        }
    }

    @objc func donePickerClicked(){
        self.view.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == self.txtCardNumber{
            previousTextFieldContent = textField.text;
            previousSelection = textField.selectedTextRange;
            return true
        }
        else if textField == self.txtCVC{
            let str = (self.txtCVC.text! + string)
            if str.count <= 3 {
                return true
            }
            else{
                return false
            }
        }
        else if (textField == txtExpires){
            if range.length > 0 {
                return true
            }
            if string == "" {
                return false
            }
            if range.location > 6 {
                return false
            }
            var originalText = textField.text
            let replacementText = string.replacingOccurrences(of: " ", with: "")
            
            //Verify entered text is a numeric value
            if !CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: replacementText)) {
                return false
            }
            
            //Put / after 2 digit
            if range.location == 2 {
                originalText?.append("/")
                textField.text = originalText
            }
            return true
        }
        
        
        return true
    }
    
    @objc func reformatAsCardNumber(textField: UITextField) {
        var targetCursorPosition = 0
        if let startPosition = textField.selectedTextRange?.start {
            targetCursorPosition = textField.offset(from: textField.beginningOfDocument, to: startPosition)
        }
        
        var cardNumberWithoutSpaces = ""
        if let text = textField.text {
            cardNumberWithoutSpaces = self.removeNonDigits(string: text, andPreserveCursorPosition: &targetCursorPosition)
        }
        
        if cardNumberWithoutSpaces.count > 16 {
            textField.text = previousTextFieldContent
            textField.selectedTextRange = previousSelection
            return
        }
        
        let cardNumberWithSpaces = self.insertCreditCardSpaces(cardNumberWithoutSpaces, preserveCursorPosition: &targetCursorPosition)
        textField.text = cardNumberWithSpaces
        
        if let targetPosition = textField.position(from: textField.beginningOfDocument, offset: targetCursorPosition) {
            textField.selectedTextRange = textField.textRange(from: targetPosition, to: targetPosition)
        }
    }
    
    func removeNonDigits(string: String, andPreserveCursorPosition cursorPosition: inout Int) -> String {
        var digitsOnlyString = ""
        let originalCursorPosition = cursorPosition
        
        for i in Swift.stride(from: 0, to: string.count, by: 1) {
            let characterToAdd = string[string.index(string.startIndex, offsetBy: i)]
            if characterToAdd >= "0" && characterToAdd <= "9" {
                digitsOnlyString.append(characterToAdd)
            }
            else if i < originalCursorPosition {
                cursorPosition -= 1
            }
        }
        
        return digitsOnlyString
    }
    
    func insertCreditCardSpaces(_ string: String, preserveCursorPosition cursorPosition: inout Int) -> String {
        // Mapping of card prefix to pattern is taken from
        // https://baymard.com/checkout-usability/credit-card-patterns
        
        // UATP cards have 4-5-6 (XXXX-XXXXX-XXXXXX) format
        let is456 = string.hasPrefix("1")
        
        // These prefixes reliably indicate either a 4-6-5 or 4-6-4 card. We treat all these
        // as 4-6-5-4 to err on the side of always letting the user type more digits.
        let is465 = [
            // Amex
            "34", "37",
            
            // Diners Club
            "300", "301", "302", "303", "304", "305", "309", "36", "38", "39"
            ].contains { string.hasPrefix($0) }
        
        // In all other cases, assume 4-4-4-4-3.
        // This won't always be correct; for instance, Maestro has 4-4-5 cards according
        // to https://baymard.com/checkout-usability/credit-card-patterns, but I don't
        // know what prefixes identify particular formats.
        let is4444 = !(is456 || is465)
        
        var stringWithAddedSpaces = ""
        let cursorPositionInSpacelessString = cursorPosition
        
        for i in 0..<string.count {
            let needs465Spacing = (is465 && (i == 4 || i == 10 || i == 15))
            let needs456Spacing = (is456 && (i == 4 || i == 9 || i == 15))
            let needs4444Spacing = (is4444 && i > 0 && (i % 4) == 0)
            
            if needs465Spacing || needs456Spacing || needs4444Spacing {
                stringWithAddedSpaces.append(" ")
                
                if i < cursorPositionInSpacelessString {
                    cursorPosition += 1
                }
            }
            
            let characterToAdd = string[string.index(string.startIndex, offsetBy:i)]
            stringWithAddedSpaces.append(characterToAdd)
        }
        
        return stringWithAddedSpaces
    }
    
    func getPlanDetails(){
        let parameters: [String: String] = [:]
        APIHelper().get(apiUrl: GlobalConstants.APIUrls.getPlanDetails, parameters: parameters as [String : AnyObject]) { (response) in
            if response["data"].array != nil  {
                //let planId = response["data"][0]["id"] != JSON.null ? response["data"][0]["id"].stringValue : ""
                self.lblTitle.text = response["data"][0]["nickname"] != JSON.null ? response["data"][0]["nickname"].stringValue : ""
                self.amount = response["data"][0]["amount"] != JSON.null ? response["data"][0]["amount"].intValue : 0
                self.lblAmount.text = "Amount $\(String(describing: self.amount!))"
            }
        }
    }
    
    @IBAction func payNowClicked(_ sender: Any) {
        self.view.endEditing(true)
        NotificationsHelper.showBusyIndicator(message: "")
        if txtCardNumber.text?.count == 0 || txtCVC.text?.count == 0 || txtCardName.text?.count == 0 || txtExpires.text?.count == 0 || txtCardName.text?.count == 0 || txtStreet.text?.count == 0 || txtStreet2.text?.count == 0 || txtState.text?.count == 0 || txtCountry.text?.count == 0 || txtCity.text?.count == 0 || txtPostal.text?.count == 0 || phoneNumberTxt.text?.count == 0 {
            self.view.makeToast("Please enter all card details.", duration: 3.0, position: .bottom)
            return
        }
        if(!isValidPhone(testStr: phoneNumberTxt.text!)){
            self.view.makeToast("Please enter valid phone number.", duration: 3.0, position: .bottom, style: style)
            return
        }
        
        let cardNumber = txtCardNumber.text!.replacingOccurrences(of: " ", with: "")
        let cardParams = STPCardParams()
        cardParams.number = cardNumber
        cardParams.expMonth = UInt(self.txtExpires.text!.prefix(2))!
        cardParams.expYear = UInt(self.txtExpires.text!.suffix(4))!
        cardParams.cvc = txtCVC.text
        cardParams.name = txtCardName.text
        cardParams.address.line1 = txtStreet.text
        cardParams.address.line2 = txtStreet2.text
        cardParams.address.state = txtState.text
        cardParams.address.country = txtCountry.text
        cardParams.address.city = txtCity.text
        cardParams.address.postalCode = txtPostal.text
        cardParams.address.phone = phoneNumberTxt.text
        
        STPAPIClient.shared().createToken(withCard: cardParams) { (token: STPToken?, error: Error?) in
            guard let token = token, error == nil
                else {
            
                    self.view.makeToast(error?.localizedDescription, duration: 3.0, position: .bottom, style: self.style)
                    print(error?.localizedDescription)
                    NotificationsHelper.hideBusyIndicator()
                    return
            }
            print(token.stripeID)
            self.stripeCardToken = token.stripeID
            self.attachSubscriptionSource()
        }
    }
    
    func attachSubscriptionSource(){
        let parameters: [String: Any] = ["stripecustomertokenid": stripeCustomerTokenId!, "stripecardtoken": stripeCardToken!]
        APIHelper().post(apiUrl: GlobalConstants.APIUrls.attachSubscriptionSource, parameters: parameters as [String : AnyObject]) { (response) in
            if response["status"].stringValue == "Success"{
                //response["data"]["carddetails"] != nil
                    self.chargeMember()
                //}
            }
        }
    }
    
    func chargeMember(){
        let amt = (amount! * 100)
        let parameters: [String: Any] = ["amount": amt, "customerstripetoken": stripeCustomerTokenId!]
        APIHelper().post(apiUrl: GlobalConstants.APIUrls.chargeMember, parameters: parameters as [String : AnyObject]) { (response) in
            if response["status"].stringValue == "Success"{
                self.view.makeToast("Payment successful!", duration: 3.0, position: .bottom, style: self.style)
                
                self.saveToCoreData()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
                    self.navigateToLogin()
                })
            }
        }
    }
    func saveToCoreData()
    {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate?.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "CardDetails", in: managedContext!)!
        
        let user = NSManagedObject(entity: entity, insertInto: managedContext!)

        user.setValue(self.singleTon.userId, forKey: "userId")
        user.setValue(self.txtCardNumber.text!, forKey: "cardNumber")
        user.setValue(self.txtExpires.text!, forKey: "expDate")
        
        user.setValue(self.txtCardName.text!, forKey: "nameBilling")
        user.setValue(self.txtStreet.text!, forKey: "streetBilling")
        user.setValue(self.txtStreet2.text!, forKey: "streetLineBilling")
        user.setValue(self.txtCity.text!, forKey: "cityBilling")
        user.setValue(self.txtPostal.text!, forKey: "postalCodeBilling")
        user.setValue(self.txtState.text!, forKey: "stateBilling")
        user.setValue(self.txtCountry.text!, forKey: "countryBilling")
        user.setValue(self.phoneNumberTxt.text!, forKey: "phoneNoBilling")
        
        do
        {
            try managedContext?.save()
        }
        catch let error as NSError
        {
            print("errorCoreData : ", error.userInfo)
        }
        
       // self.saveShippingAddress()
    }
    func saveShippingAddress()
    {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate?.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "ShippingAddress", in: managedContext!)!
        
        let user = NSManagedObject(entity: entity, insertInto: managedContext!)
 
        user.setValue(self.txtCardName.text!, forKey: "name")
        user.setValue(self.txtStreet.text!, forKey: "street")
        user.setValue(self.txtStreet2.text!, forKey: "streetLine")
        user.setValue(self.txtCity.text!, forKey: "city")
        user.setValue(self.txtPostal.text!, forKey: "postalCode")
        user.setValue(self.txtState.text!, forKey: "state")
        user.setValue(self.txtCountry.text!, forKey: "country")
        user.setValue(self.phoneNumberTxt.text!, forKey: "phoneNumber")
        
        do
        {
            try managedContext?.save()
        }
        catch let error as NSError
        {
            print("errorCoreData : ", error.userInfo)
        }
    }
    
    @IBAction func backClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
