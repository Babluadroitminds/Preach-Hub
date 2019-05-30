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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.tickImage.isHidden = true
        
        viewDot.layer.borderColor = UIColor.clear.cgColor
        viewDot.layer.borderWidth = 2.0
        viewDot.layer.cornerRadius = 9.0
        viewDot.addViewDashedBorder(view: viewDot)

        self.datePicker.datePickerMode = NTMonthYearPickerModeMonthAndYear
        self.datePicker.minimumDate = Date()
        
        self.datePicker.addTarget(self, action: #selector(onDatePicked), for: .valueChanged)
        self.expDateTxt.inputView = self.datePicker
        
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
       self.navigateToAddBillingPage()
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
        if self.cardNumber.text! == "" || self.expDateTxt.text! == "" || self.cvvTxt.text! == ""
        {
            let style = ToastStyle()
            
            self.view.makeToast("Please enter all card details", duration: 3.0, position: .bottom, style: style)
            return
        }
        if self.singleTon.nameBilling == "" && self.tickImage.isHidden == true
        {
            let style = ToastStyle()
            
            self.view.makeToast("Please Add Billing Address", duration: 3.0, position: .bottom, style: style)
            return
        }
        
        if self.tickImage.isHidden == false
        {
            self.singleTon.nameBilling = self.singleTon.nameShipping
            self.singleTon.streetBilling = self.singleTon.streetShipping
            self.singleTon.streetLine2Billing = self.singleTon.streetLine2Shipping
            self.singleTon.cityBilling = self.singleTon.cityShipping
            self.singleTon.postalCodeBilling = self.singleTon.postalCodeShipping
            self.singleTon.stateBilling = self.singleTon.stateShipping
            self.singleTon.countryBilling = self.singleTon.countryShipping
            self.singleTon.phoneNumberBilling = self.singleTon.phoneNumberShipping
        }
        self.saveToCoreData()
    }
    func saveToCoreData()
    {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate?.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "CardDetails", in: managedContext!)!
        
        let user = NSManagedObject(entity: entity, insertInto: managedContext!)
        
        user.setValue(self.cardNumber.text!, forKey: "cardNumber")
        user.setValue(self.expDateTxt.text!, forKey: "expDate")
        
        user.setValue(self.singleTon.nameShipping, forKey: "nameShipping")
        user.setValue(self.singleTon.streetShipping, forKey: "streetShipping")
        user.setValue(self.singleTon.streetLine2Shipping, forKey: "streetLineShipping")
        user.setValue(self.singleTon.cityShipping, forKey: "cityShipping")
        user.setValue(self.singleTon.postalCodeShipping, forKey: "postalCodeShipping")
        user.setValue(self.singleTon.stateShipping, forKey: "stateShipping")
        user.setValue(self.singleTon.countryShipping, forKey: "countryShipping")
        user.setValue(self.singleTon.phoneNumberShipping, forKey: "phoneNoShipping")
        
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
        
        self.singleTon.nameShipping = ""
        self.singleTon.streetShipping = ""
        self.singleTon.streetLine2Shipping = ""
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
    func addViewDashedBorder(view : UIView)
    {
        let color = UIColor.gray.cgColor
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let shapeRect = CGRect(x: 0, y: 0, width: view.layer.frame.width + 50, height: view.layer.frame.height)
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: view.layer.frame.width/2 + 25, y: view.layer.frame.height/2)
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
