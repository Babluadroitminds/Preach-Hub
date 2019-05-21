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

class PaymentViewController: UIViewController {
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtCardName: UITextField!
    @IBOutlet weak var txtExpires: UITextField!
    @IBOutlet weak var txtCVC: UITextField!
    @IBOutlet weak var txtCardNumber: UITextField!
    private var previousTextFieldContent: String?
    private var previousSelection: UITextRange?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        getPlanDetails()
    }
    
    func setLayout(){
        txtCardNumber.delegate = self
        txtCardNumber.keyboardType = .numberPad
        txtExpires.keyboardType = .numberPad
        txtExpires.delegate = self
        txtCardNumber.addTarget(self, action: #selector(reformatAsCardNumber), for: .editingChanged)
        txtCVC.keyboardType = .numberPad
        txtCVC.delegate = self
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
            if response["status"].string == "Success" {
                self.lblTitle.text = response["data"][0]["title"] != JSON.null ? response["data"][0]["title"].stringValue : ""
                let amount = response["data"][0]["price"] != JSON.null ? response["data"][0]["price"].intValue : 0
                self.lblAmount.text = "Amount \(amount)"
            }
        }
    }
    
    @IBAction func payNowClicked(_ sender: Any) {
        if txtCardNumber.text?.count == 0 || txtCVC.text?.count == 0 || txtCardName.text?.count == 0 || txtExpires.text?.count == 0 {
            self.view.makeToast("Please enter all card details.", duration: 3.0, position: .bottom)
            return
        }

        let cardNumber = txtCardNumber.text!.replacingOccurrences(of: " ", with: "")
        let cardParams = STPCardParams()
        cardParams.number = cardNumber
        cardParams.expMonth = UInt(self.txtExpires.text!.prefix(2))!
        cardParams.expYear = UInt(self.txtExpires.text!.suffix(4))!
        cardParams.cvc = txtCVC.text
        
        
        STPAPIClient.shared().createToken(withCard: cardParams) { (token: STPToken?, error: Error?) in
            guard let token = token, error == nil
                else {
                    print(error.debugDescription)
                    return
            }
            
        print(token)
            
        }
    }
}