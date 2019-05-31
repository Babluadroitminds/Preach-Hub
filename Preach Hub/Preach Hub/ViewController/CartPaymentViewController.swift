//
//  CartPaymentViewController.swift
//  Preach Hub
//
//  Created by Adroitminds on 28/05/19.
//  Copyright © 2019 AdroitMinds. All rights reserved.
//

import UIKit
import NTMonthYearPicker
import CoreData
import Toast_Swift
import SwiftyJSON
import Stripe

class CartPaymentViewController: UIViewController
{
    @IBOutlet weak var tickImage: UIImageView!
    @IBOutlet weak var viewDot: UIView!
    @IBOutlet weak var expDateTxt: UITextField!
    @IBOutlet weak var cardNumber: UITextField!
    @IBOutlet weak var cvvTxt: UITextField!

    var datePicker = NTMonthYearPicker()
    var singleTon = SingleTon.shared

    private var previousTextFieldContent: String?
    private var previousSelection: UITextRange?
    
    var stripeCustomerTokenId: String?
    var stripeCardToken: String?
    
    var style = ToastStyle()
    var cartList: [[String: String]] = []
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.tickImage.isHidden = true
        
        cvvTxt.delegate = self
        expDateTxt.delegate = self
        
        viewDot.layer.borderColor = UIColor.clear.cgColor
        viewDot.layer.borderWidth = 2.0
        viewDot.layer.cornerRadius = 9.0
        viewDot.addViewDashedBorder(view: viewDot, width: 40, xVal: 20)

//        self.datePicker.datePickerMode = NTMonthYearPickerModeMonthAndYear
//        self.datePicker.minimumDate = Date()
//
//        self.datePicker.addTarget(self, action: #selector(onDatePicked), for: .valueChanged)
//        self.expDateTxt.inputView = self.datePicker
        
        cardNumber.delegate = self
        cardNumber.keyboardType = .numberPad
        cardNumber.addTarget(self, action: #selector(reformatAsCardNumber), for: .editingChanged)
    }
    @objc func onDatePicked()
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/yy"
        
        let dateStr = dateFormatter.string(from: self.datePicker.date)
        
        self.expDateTxt.text = dateStr
    }
    @IBAction func backTapped(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func addBillingTapped(_ sender: Any)
    {
        if self.cardNumber.text! == "" || self.expDateTxt.text! == "" || self.cvvTxt.text! == ""
        {
            self.view.makeToast("Please enter all card details", duration: 3.0, position: .bottom, style: self.style)
            return
        }
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "CartPayment", bundle:nil)
        let paymentViewController = storyBoard.instantiateViewController(withIdentifier: "AddBillingAddressViewController") as! AddBillingAddressViewController
        
        paymentViewController.cardNumber = self.cardNumber.text!
        paymentViewController.expDate = self.expDateTxt.text!
        paymentViewController.cvc = self.cvvTxt.text!
        
        self.navigationController?.pushViewController(paymentViewController, animated: true)
    }
    @IBAction func sameBillingTapped(_ sender: Any)
    {
        if self.tickImage.isHidden == false
        {
            self.tickImage.isHidden = true
        }
        else
        {
            self.tickImage.isHidden = false
        }
    }
    @IBAction func payNowTapped(_ sender: Any)
    {
        self.view.endEditing(false)
        if self.cardNumber.text! == "" || self.expDateTxt.text! == "" || self.cvvTxt.text! == ""
        {
            self.view.makeToast("Please enter all card details", duration: 3.0, position: .bottom, style: self.style)
            return
        }
        if self.singleTon.nameBilling == "" && self.tickImage.isHidden == true
        {
            self.view.makeToast("Please Add Billing Address", duration: 3.0, position: .bottom, style: self.style)
            return
        }
        
        if self.tickImage.isHidden == false
        {
            let fullName = self.singleTon.firstNameShipping + " " + self.singleTon.lastNameShipping
            
            self.singleTon.nameBilling = fullName
            self.singleTon.streetBilling = self.singleTon.addressShipping
            self.singleTon.streetLine2Billing = self.singleTon.streeLine2Shipping
            self.singleTon.cityBilling = self.singleTon.cityShipping
            self.singleTon.postalCodeBilling = self.singleTon.postalCodeShipping
            self.singleTon.stateBilling = self.singleTon.stateShipping
            self.singleTon.countryBilling = self.singleTon.countryShipping
            self.singleTon.phoneNumberBilling = self.singleTon.phoneNumberShipping
        }
        
        NotificationsHelper.showBusyIndicator(message: "")
        
        let cardNumber = self.cardNumber.text!.replacingOccurrences(of: " ", with: "")
        let cardParams = STPCardParams()
        cardParams.number = cardNumber
        cardParams.expMonth = UInt(self.expDateTxt.text!.prefix(2))!
        cardParams.expYear = UInt(self.expDateTxt.text!.suffix(4))!
        cardParams.cvc = cvvTxt.text
        cardParams.name = self.singleTon.nameBilling
        cardParams.address.line1 = self.singleTon.streetBilling
        cardParams.address.line2 = self.singleTon.streetLine2Billing
        cardParams.address.state = self.singleTon.stateBilling
        cardParams.address.country = self.singleTon.countryBilling
        cardParams.address.city = self.singleTon.cityBilling
        cardParams.address.postalCode = self.singleTon.postalCodeBilling
        cardParams.address.phone = self.singleTon.phoneNumberBilling
        
        STPAPIClient.shared().createToken(withCard: cardParams) { (token: STPToken?, error: Error?) in
            guard let token = token, error == nil
                else {
                    
                    self.view.makeToast(error?.localizedDescription, duration: 3.0, position: .bottom, style: self.style)
                    NotificationsHelper.hideBusyIndicator()
                    return
            }
            print(token.stripeID)
            self.stripeCardToken = token.stripeID
            
            self.saveToCoreData()
            
           // self.sendOrder()
        }
    }
   
    func saveToCoreData()
    {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate?.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "CardDetails", in: managedContext!)!
        
        let user = NSManagedObject(entity: entity, insertInto: managedContext!)
        
        user.setValue(self.cardNumber.text!, forKey: "cardNumber")
        user.setValue(self.expDateTxt.text!, forKey: "expDate")
        
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
        
        self.cvvTxt.text = ""
        self.cardNumber.text = ""
        self.expDateTxt.text = ""
        
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
        
        self.tickImage.isHidden = true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == self.cardNumber
        {
            previousTextFieldContent = textField.text;
            previousSelection = textField.selectedTextRange;
            
            return true
        }
        else if textField == self.cvvTxt
        {
            let str = (self.cvvTxt.text! + string)
            if str.count <= 3
            {
                return true
            }
            else{
                return false
            }
        }
        else if (textField == expDateTxt)
        {
            if range.length > 0
            {
                return true
            }
            if string == ""
            {
                return false
            }
            if range.location > 6
            {
                return false
            }
            var originalText = textField.text
            let replacementText = string.replacingOccurrences(of: " ", with: "")
            
            //Verify entered text is a numeric value
            if !CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: replacementText))
            {
                return false
            }
            
            if range.location == 2
            {
                originalText?.append("/")
                textField.text = originalText
            }
            return true
        }
        
        return true
    }
    
    @objc func reformatAsCardNumber(textField: UITextField)
    {
        var targetCursorPosition = 0
        if let startPosition = textField.selectedTextRange?.start {
            targetCursorPosition = textField.offset(from: textField.beginningOfDocument, to: startPosition)
        }
        
        var cardNumberWithoutSpaces = ""
        if let text = textField.text
        {
            cardNumberWithoutSpaces = self.removeNonDigits(string: text, andPreserveCursorPosition: &targetCursorPosition)
        }
        
        if cardNumberWithoutSpaces.count > 16
        {
            textField.text = previousTextFieldContent
            textField.selectedTextRange = previousSelection
            return
        }
        
        let cardNumberWithSpaces = self.insertCreditCardSpaces(cardNumberWithoutSpaces, preserveCursorPosition: &targetCursorPosition)
        textField.text = cardNumberWithSpaces
        
        if let targetPosition = textField.position(from: textField.beginningOfDocument, offset: targetCursorPosition)
        {
            textField.selectedTextRange = textField.textRange(from: targetPosition, to: targetPosition)
        }
    }
    
    func removeNonDigits(string: String, andPreserveCursorPosition cursorPosition: inout Int) -> String {
        var digitsOnlyString = ""
        let originalCursorPosition = cursorPosition
        
        for i in Swift.stride(from: 0, to: string.count, by: 1)
        {
            let characterToAdd = string[string.index(string.startIndex, offsetBy: i)]
            if characterToAdd >= "0" && characterToAdd <= "9"
            {
                digitsOnlyString.append(characterToAdd)
            }
            else if i < originalCursorPosition
            {
                cursorPosition -= 1
            }
        }
        
        return digitsOnlyString
    }
    
    func insertCreditCardSpaces(_ string: String, preserveCursorPosition cursorPosition: inout Int) -> String
    {
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
    
}
extension UIView
{
    func addViewDashedBorder(view : UIView, width: CGFloat, xVal: CGFloat)
    {
        let color = UIColor.gray.cgColor
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let shapeRect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - width, height: view.layer.frame.height)//view.layer.frame.width + width, height: view.layer.frame.height)
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: UIScreen.main.bounds.width/2 - xVal, y: view.layer.frame.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 2
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [6,3]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 9).cgPath
        shapeLayer.layoutIfNeeded()
        self.layer.addSublayer(shapeLayer)
    }
}
