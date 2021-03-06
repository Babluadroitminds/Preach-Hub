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
import Stripe
import Toast_Swift
import SwiftyJSON

struct cardDetailsVal
{
    var cardNumber : String
    var expDate : String
    
    var nameBilling : String
    var streetBilling : String
    var streetLine2Billing : String
    var cityBilling : String
    var postalCodeBilling : String
    var stateBilling : String
    var countryBilling : String
    var phoneNumberBilling : String
}
class PaymentExistingCardCollectionViewCell: UICollectionViewCell
{
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var expDateTxt: UITextField!
    @IBOutlet weak var cardNumber: UITextField!
    @IBOutlet weak var cvvTxt: UITextField!
}
class PaymentExistingCardViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate
{
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewDot: UIView!

    var cardDetailsArr = [cardDetailsVal]()
    
    var currentIndex = 0
    
    var cvvArr = [String]()
    
    var stripeCustomerTokenId: String?
    var stripeCardToken: String?
    
    var style = ToastStyle()
    var cartList: [[String: String]] = []
    var orderId: String?
    var orderNo: String?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        viewDot.layer.borderColor = UIColor.clear.cgColor
        viewDot.layer.borderWidth = 2.0
        viewDot.layer.cornerRadius = 10.0
        viewDot.addViewDashedBorder(view: viewDot, width: 44, xVal: 21)
        
//        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeRight(gestureRecognizer:)))
//        swipeRight.delegate = self
//        swipeRight.numberOfTouchesRequired = 1
//        swipeRight.direction = .right
//
//        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeLeft(gestureRecognizer:)))
//        swipeLeft.delegate = self
//        swipeLeft.numberOfTouchesRequired = 1
//        swipeLeft.direction = .left
//
//        self.collectionView.addGestureRecognizer(swipeRight)
//        self.collectionView.addGestureRecognizer(swipeLeft)
    }
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        self.cvvArr[self.currentIndex] = textField.text!
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if self.cardDetailsArr.count == 0
        {
            return 1
        }
        return self.cardDetailsArr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "existingCardCell", for: indexPath) as? PaymentExistingCardCollectionViewCell
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeRight(gestureRecognizer:)))
        swipeRight.delegate = self
        swipeRight.numberOfTouchesRequired = 1
        swipeRight.delaysTouchesBegan = true
        swipeRight.direction = .right
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeLeft(gestureRecognizer:)))
        swipeLeft.delegate = self
        swipeLeft.numberOfTouchesRequired = 1
        swipeLeft.delaysTouchesBegan = true
        swipeLeft.direction = .left
        
        cell?.addGestureRecognizer(swipeRight)
        cell?.addGestureRecognizer(swipeLeft)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapLeft(gestureRecognizer:)))
        cell?.leftView.addGestureRecognizer(tap)
        
        let tapRight = UITapGestureRecognizer(target: self, action: #selector(didTapRight(gestureRecognizer:)))
        cell?.rightView.addGestureRecognizer(tapRight)
        
        cell?.cvvTxt.delegate = self
        
        cell?.leftView.isHidden = false
        cell?.rightView.isHidden = false
        
        if self.cardDetailsArr.count == 0
        {
            cell?.leftView.isHidden = true
            cell?.rightView.isHidden = true
            
            cell?.cvvTxt.isEnabled = false
        }
        else
        {
            cell?.cvvTxt.text = self.cvvArr[self.currentIndex]

            let last4Digit = self.cardDetailsArr[self.currentIndex].cardNumber.suffix(4)
        
            cell?.cardNumber.text = "xxxx xxxx xxxx \(last4Digit)"
            
            cell?.expDateTxt.text = self.cardDetailsArr[self.currentIndex].expDate
            
            if self.cardDetailsArr.count == 1
            {
                cell?.leftView.isHidden = true
                cell?.rightView.isHidden = true
            }
            else
            {
                if currentIndex == 0
                {
                    cell?.leftView.isHidden = true
                    cell?.rightView.isHidden = false
                }
//                else if currentIndex - 1 == 0
//                {
//                    cell?.leftView.isHidden = true
//                    cell?.rightView.isHidden = false
//                }
                else if self.currentIndex + 1 == self.cardDetailsArr.count
                {
                    cell?.rightView.isHidden = true
                    cell?.leftView.isHidden = false
                }
            }
        }
        
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let screenSize = UIScreen.main.bounds
        
        return CGSize(width: screenSize.width, height: 185)
    }
    override func viewWillAppear(_ animated: Bool)
    {
        self.fetchCoreData()
    }
    @objc func didTapLeft(gestureRecognizer : UITapGestureRecognizer)
    {
        print("self.TapLeft :", self.currentIndex)
        
        if self.currentIndex != 0
        {
            self.currentIndex = self.currentIndex  - 1
            
            let indexPath = IndexPath(row: self.currentIndex, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
            
            self.collectionView.reloadData()
        }
    }
    @objc func didTapRight(gestureRecognizer : UITapGestureRecognizer)
    {
        print("self.TapRight :", self.currentIndex)
        
        if self.currentIndex != self.cardDetailsArr.count
        {
            self.currentIndex = self.currentIndex + 1
            
            let indexPath = IndexPath(row: self.currentIndex, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: .right, animated: true)
            
            self.collectionView.reloadData()
        }
    }
    @objc func didSwipeRight(gestureRecognizer : UISwipeGestureRecognizer)
    {
        print("self.currentIndexRight :", self.currentIndex)

        if self.cardDetailsArr.count != 0
        {
            if self.currentIndex != 0
            {
                self.currentIndex = self.currentIndex  - 1
                
                let indexPath = IndexPath(row: self.currentIndex, section: 0)
                self.collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
                
                self.collectionView.reloadData()
            }
        }
    }
    @objc func didSwipeLeft(gestureRecognizer : UISwipeGestureRecognizer)
    {
        print("self.currentIndexLeft :", self.currentIndex)
        
        if self.cardDetailsArr.count != 0
        {
            if self.currentIndex + 1 != self.cardDetailsArr.count
            {
                self.currentIndex = self.currentIndex + 1
                
                let indexPath = IndexPath(row: self.currentIndex, section: 0)
                self.collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
                
                self.collectionView.reloadData()
            }
        }
    }
    func fetchCoreData()
    {
        self.cardDetailsArr.removeAll()
        self.cvvArr.removeAll()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate?.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CardDetails")
        
        let userId = UserDefaults.standard.value(forKey: "memberId") as? String
        
        do
        {
            let result = try managedContext?.fetch(fetchRequest)

            for data in result as! [NSManagedObject]
            {
                if userId == (data.value(forKey: "userId") as! String)
                {
                    self.cardDetailsArr.append(cardDetailsVal(cardNumber: data.value(forKey: "cardNumber") as! String, expDate: data.value(forKey: "expDate") as! String, nameBilling: data.value(forKey: "nameBilling") as! String, streetBilling: data.value(forKey: "streetBilling") as! String, streetLine2Billing: data.value(forKey: "streetLineBilling") as! String, cityBilling: data.value(forKey: "cityBilling") as! String, postalCodeBilling: data.value(forKey: "postalCodeBilling") as! String, stateBilling: data.value(forKey: "stateBilling") as! String, countryBilling: data.value(forKey: "countryBilling") as! String, phoneNumberBilling: data.value(forKey: "phoneNoBilling") as! String))
                
                    self.cvvArr.append("")
                }
            }
            
            print("self.cardDetailsArr : ", self.cardDetailsArr)
            
            
            
            self.collectionView.reloadData()
            
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
    
    @IBAction func addNewCardTapped(_ sender: Any){
        let cartPaymentVC = CartPaymentViewController.storyboardInstance()
        cartPaymentVC?.orderId = orderId
        cartPaymentVC?.orderNo = orderNo
        self.navigationController?.pushViewController(cartPaymentVC!, animated: true)
    }
    
    @IBAction func leftTapped(_ sender: Any)
    {
        if self.currentIndex != 0
        {
            self.currentIndex = self.currentIndex  - 1
            
            let indexPath = IndexPath(row: self.currentIndex, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
            
            self.collectionView.reloadData()
        }
    }
    @IBAction func rightTapped(_ sender: Any)
    {
        if self.currentIndex != self.cardDetailsArr.count
        {
            self.currentIndex = self.currentIndex + 1
            
            let indexPath = IndexPath(row: self.currentIndex, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: .right, animated: true)
            
            self.collectionView.reloadData()
        }
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool
    {
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        print("self.currentIndex : ", self.currentIndex)
        
//        let indexPath = IndexPath(row: self.currentIndex, section: 0)
//        let cell = self.collectionView.cellForItem(at: indexPath) as? PaymentExistingCardCollectionViewCell
        
        let str = (textField.text! + string)
        
        if str.count <= 3
        {
            return true
        }
        else
        {
            return false
        }        
    }
    @IBAction func payNowTapped(_ sender: Any)
    {
        self.view.endEditing(false)
        if self.cvvArr.count == 0
        {
            self.view.makeToast("Please Add a New Card", duration: 3.0, position: .bottom, style: self.style)
            return
        }
        if self.cvvArr[self.currentIndex] == ""
        {
            self.view.makeToast("Please enter all card details", duration: 3.0, position: .bottom, style: self.style)
            return
        }
        NotificationsHelper.showBusyIndicator(message: "")
        
        let cardNumber = self.cardDetailsArr[self.currentIndex].cardNumber.replacingOccurrences(of: " ", with: "")
        let cardParams = STPCardParams()
        cardParams.number = cardNumber
        cardParams.expMonth = UInt(self.cardDetailsArr[self.currentIndex].expDate.prefix(2))!
        cardParams.expYear = UInt(self.cardDetailsArr[self.currentIndex].expDate.suffix(4))!
        cardParams.cvc = self.cvvArr[self.currentIndex]
        cardParams.name = self.cardDetailsArr[self.currentIndex].nameBilling
        cardParams.address.line1 = self.cardDetailsArr[self.currentIndex].streetBilling
        cardParams.address.line2 = self.cardDetailsArr[self.currentIndex].streetLine2Billing
        cardParams.address.state = self.cardDetailsArr[self.currentIndex].stateBilling
        cardParams.address.country = self.cardDetailsArr[self.currentIndex].countryBilling
        cardParams.address.city = self.cardDetailsArr[self.currentIndex].cityBilling
        cardParams.address.postalCode = self.cardDetailsArr[self.currentIndex].postalCodeBilling
        cardParams.address.phone = self.cardDetailsArr[self.currentIndex].phoneNumberBilling
        
        STPAPIClient.shared().createToken(withCard: cardParams) { (token: STPToken?, error: Error?) in
            guard let token = token, error == nil
                else {
                    
                    self.view.makeToast(error?.localizedDescription, duration: 3.0, position: .bottom, style: self.style)
                    NotificationsHelper.hideBusyIndicator()
                    return
            }
            print(token.stripeID)
            
            self.stripeCardToken = token.stripeID
            NotificationsHelper.hideBusyIndicator()
            self.chargeMemberCard()
        }
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
        let amount = (sum + shippingAmount) * 100
        let memberId = UserDefaults.standard.string(forKey: "memberId")
        
        //let stripeCustomerTokenId = UserDefaults.standard.string(forKey: "stripeCustomerTokenId")
        let parameters: [String: Any] = ["amount": amount, "cardToken": stripeCardToken!, "orderno": orderNo!]
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
    
    static func storyboardInstance() -> PaymentExistingCardViewController? {
        let storyboard = UIStoryboard(name: "CartPayment", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "PaymentExistingCardViewController") as? PaymentExistingCardViewController
    }
}

