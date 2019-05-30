//
//  PaymentExistingCardViewController.swift
//  Preach Hub
//
//  Created by Sajeev Sasidharan on 28/05/19.
//  Copyright © 2019 AdroitMinds. All rights reserved.
//

import UIKit
import NTMonthYearPicker
import CoreData

struct cardDetailsVal
{
    var cardNumber : String
    var expDate : String
    
    var nameShipping : String
    var streetShipping : String
    var streetLine2Shipping : String
    var cityShipping : String
    var postalCodeShipping : String
    var stateShipping : String
    var countryShipping : String
    var phoneNumberShipping : String
    
    var nameBilling : String
    var streetBilling : String
    var streetLine2Billing : String
    var cityBilling : String
    var postalCodeBilling : String
    var stateBilling : String
    var countryBilling : String
    var phoneNumberBilling : String
}

class PaymentExistingCardViewController: UIViewController
{
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var viewDot: UIView!
    @IBOutlet weak var expDateTxt: UITextField!
    @IBOutlet weak var cardNumber: UITextField!
    @IBOutlet weak var cvvTxt: UITextField!

    var cardDetailsArr = [cardDetailsVal]()
    
    var currentIndex = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        viewDot.layer.borderColor = UIColor.clear.cgColor
        viewDot.layer.borderWidth = 2.0
        viewDot.layer.cornerRadius = 10.0
        viewDot.addViewDashedBorder(view: viewDot)
    }
    override func viewWillAppear(_ animated: Bool)
    {
        self.fetchCoreData()
    }
    func fetchCoreData()
    {
        self.cardDetailsArr.removeAll()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate?.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CardDetails")
        
        do
        {
            let result = try managedContext?.fetch(fetchRequest)

            for data in result as! [NSManagedObject]
            {
                self.cardDetailsArr.append(cardDetailsVal(cardNumber: data.value(forKey: "cardNumber") as! String, expDate: data.value(forKey: "expDate") as! String, nameShipping: data.value(forKey: "nameShipping") as! String, streetShipping: data.value(forKey: "streetShipping") as! String, streetLine2Shipping: data.value(forKey: "streetLineShipping") as! String, cityShipping: data.value(forKey: "cityShipping") as! String, postalCodeShipping: data.value(forKey: "postalCodeShipping") as! String, stateShipping: data.value(forKey: "stateShipping") as! String, countryShipping: data.value(forKey: "countryShipping") as! String, phoneNumberShipping: data.value(forKey: "phoneNoShipping") as! String, nameBilling: data.value(forKey: "nameBilling") as! String, streetBilling: data.value(forKey: "streetBilling") as! String, streetLine2Billing: data.value(forKey: "streetLineBilling") as! String, cityBilling: data.value(forKey: "cityBilling") as! String, postalCodeBilling: data.value(forKey: "postalCodeBilling") as! String, stateBilling: data.value(forKey: "stateBilling") as! String, countryBilling: data.value(forKey: "countryBilling") as! String, phoneNumberBilling: data.value(forKey: "phoneNoBilling") as! String))
            }
            
            if self.cardDetailsArr.count != 0
            {
                self.cardNumber.text = self.cardDetailsArr[self.currentIndex].cardNumber
                self.expDateTxt.text = self.cardDetailsArr[self.currentIndex].expDate
                
                if self.cardDetailsArr.count == 1
                {
                    self.leftView.isHidden = true
                    self.rightView.isHidden = true
                }
                else
                {
                    self.leftView.isHidden = true
                    self.rightView.isHidden = false
                }
            }
            else
            {
                self.leftView.isHidden = true
                self.rightView.isHidden = true
            }
            print("count : ", self.cardDetailsArr.count)
        }
        catch
        {
            print("coreDataFetchFail")
        }
    }
    
    @IBAction func backTapped(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func addNewCardTapped(_ sender: Any)
    {
        self.navigateToCartPaymentPage()
    }
    @IBAction func leftTapped(_ sender: Any)
    {
        if currentIndex - 1 == 0
        {
            self.leftView.isHidden = true
            self.rightView.isHidden = false
        }
        
        if self.currentIndex != 0
        {
            self.currentIndex = self.currentIndex  - 1
            
            self.cardNumber.text = self.cardDetailsArr[self.currentIndex].cardNumber
            self.expDateTxt.text = self.cardDetailsArr[self.currentIndex].expDate
        }
    }
    @IBAction func rightTapped(_ sender: Any)
    {
        print("self.currentInde222222x : ", self.currentIndex)
        
        if self.currentIndex != self.cardDetailsArr.count
        {
            self.currentIndex = self.currentIndex + 1
            
            self.cardNumber.text = self.cardDetailsArr[self.currentIndex].cardNumber
            self.expDateTxt.text = self.cardDetailsArr[self.currentIndex].expDate
        }
        
        if self.currentIndex + 1 == self.cardDetailsArr.count
        {
            self.rightView.isHidden = true
            self.leftView.isHidden = false
        }
    }
}
