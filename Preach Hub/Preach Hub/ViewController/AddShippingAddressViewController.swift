//
//  AddShippingAddressViewController.swift
//  Preach Hub
//
//  Created by Sajeev Sasidharan on 27/05/19.
//  Copyright © 2019 AdroitMinds. All rights reserved.
//

import UIKit
import Toast_Swift
import CoreData

class AddShippingAddressViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate
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
    
    var alreadyAdded = -1
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.countryTxt.delegate = self
        self.stateTxt.delegate = self
        
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
    
    override func viewWillAppear(_ animated: Bool)
    {
        if self.txtFldName.text != ""
        {
            self.alreadyAdded = 2
        }
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
        self.singleTon.nameShipping = ""
        self.singleTon.streetShipping = ""
        self.singleTon.streetLine2Shipping = ""
        self.singleTon.cityShipping = ""
        self.singleTon.postalCodeShipping = ""
        self.singleTon.stateShipping = ""
        self.singleTon.countryShipping = ""
        self.singleTon.phoneNumberShipping = ""
        
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
        
        self.singleTon.nameShipping = self.txtFldName.text!
        self.singleTon.streetShipping = self.txtFldStreet.text!
        self.singleTon.streetLine2Shipping = self.streetLine2Txt.text!
        self.singleTon.cityShipping = self.txtFldCity.text!
        self.singleTon.postalCodeShipping = self.txtFldPostalCode.text!
        self.singleTon.stateShipping = self.stateTxt.text!
        self.singleTon.countryShipping = self.countryTxt.text!
        self.singleTon.phoneNumberShipping = self.txtFldPhoneNumber.text!
        
        if self.alreadyAdded == -1
        {
            self.saveShippingAddress()
        }
        navigateToExistingCardPage()
    }
    func saveShippingAddress()
    {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate?.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "ShippingAddress", in: managedContext!)!
        
        let user = NSManagedObject(entity: entity, insertInto: managedContext!)
        
        user.setValue(self.txtFldName.text!, forKey: "name")
        user.setValue(self.txtFldStreet.text!, forKey: "street")
        user.setValue(self.streetLine2Txt.text!, forKey: "streetLine")
        user.setValue(self.txtFldCity.text!, forKey: "city")
        user.setValue(self.txtFldPostalCode.text!, forKey: "postalCode")
        user.setValue(self.stateTxt.text!, forKey: "state")
        user.setValue(self.countryTxt.text!, forKey: "country")
        user.setValue(self.txtFldPhoneNumber.text!, forKey: "phoneNumber")
        
        do
        {
            try managedContext?.save()
        }
        catch let error as NSError
        {
            print("errorCoreData : ", error.userInfo)
        }
    }
}

