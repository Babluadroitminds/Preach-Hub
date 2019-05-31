//
//  ShippingAddressViewController.swift
//  Preach Hub
//
//  Created by Sajeev Sasidharan on 27/05/19.
//  Copyright © 2019 AdroitMinds. All rights reserved.
//

import UIKit
import CoreData
import Toast_Swift
import SwiftyJSON

struct shippingAddress
{
    var firstNameShipping : String
    var lastNameShipping : String
    var addressShipping : String
    var streetLine2Shipping : String
    var emailShipping : String
    var cityShipping : String
    var postalCodeShipping : String
    var stateShipping : String
    var countryShipping : String
    var phoneNumberShipping = ""
}

class ShippingAddressTVCell : UITableViewCell
{
    @IBOutlet weak var addressLine3: UILabel!
    @IBOutlet weak var addressLine2: UILabel!
    @IBOutlet weak var addressLine1: UILabel!
    
    @IBOutlet weak var selectedBtn: UIButton!
    @IBOutlet weak var selectedView: UIView!
}
class ShippingAddressViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var viewDot: UIView!

    @IBOutlet weak var addressTableView: UITableView!

    var selectedRow = -1
    
    var shippingAddressArr = [shippingAddress]()
    var singleTon = SingleTon.shared
    var orderId: String?

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        viewDot.layer.borderColor = UIColor.clear.cgColor
        viewDot.layer.borderWidth = 2.0
        viewDot.layer.cornerRadius = 9.0
        
        viewDot.addViewDashedBorder(view: viewDot, width: 37, xVal: 21)
        
        self.addressTableView.tableFooterView = UIView()
    }
    override func viewWillAppear(_ animated: Bool)
    {
        self.fetchCoreData()
    }
    
    func fetchCoreData()
    {
        self.shippingAddressArr.removeAll()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate?.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ShippingAddress")
        
        do
        {
            let result = try managedContext?.fetch(fetchRequest)
            
            for data in result as! [NSManagedObject]
            {
                
                self.shippingAddressArr.append(shippingAddress(firstNameShipping: data.value(forKey: "firstName") as! String, lastNameShipping: data.value(forKey: "lastName") as! String, addressShipping: data.value(forKey: "street1") as! String, streetLine2Shipping: data.value(forKey: "streetLine2") as! String, emailShipping: data.value(forKey: "email") as! String, cityShipping: data.value(forKey: "city") as! String, postalCodeShipping: data.value(forKey: "postalCode") as! String, stateShipping: data.value(forKey: "state") as! String, countryShipping: data.value(forKey: "country") as! String, phoneNumberShipping: data.value(forKey: "phoneNumber") as! String))
            }
            
            print("self.shippingAddressArr : ", self.shippingAddressArr)

            
            self.addressTableView.reloadData()
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.shippingAddressArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shippingCell", for: indexPath) as! ShippingAddressTVCell
        
        let fullName = self.shippingAddressArr[indexPath.row].firstNameShipping + " " + self.shippingAddressArr[indexPath.row].lastNameShipping
        cell.addressLine1.text = fullName + ", " + self.shippingAddressArr[indexPath.row].addressShipping
        cell.addressLine2.text = self.shippingAddressArr[indexPath.row].streetLine2Shipping + ", " + self.shippingAddressArr[indexPath.row].cityShipping
        cell.addressLine3.text = self.shippingAddressArr[indexPath.row].stateShipping + ", " + self.shippingAddressArr[indexPath.row].countryShipping + ", " + self.shippingAddressArr[indexPath.row].postalCodeShipping
        
        cell.selectedBtn.tag = indexPath.row
        
        if selectedRow == indexPath.row
        {
            cell.selectedView.isHidden = false
        }
        else
        {
            cell.selectedView.isHidden = true
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.selectedRow = indexPath.row
        
        self.addressTableView.reloadData()
    }
    @IBAction func addressSelected(_ sender: UIButton)
    {
        self.selectedRow = sender.tag
        
        self.addressTableView.reloadData()
    }
    @IBAction func addShippingAddressTapped(_ sender: Any)
    {
        self.navigateToAddShippingAddressPage()
    }
    @IBAction func continuTapped(_ sender: Any)
    {
        if self.selectedRow == -1
        {
            let style = ToastStyle()
            
            self.view.makeToast("Select a Shipping Address", duration: 3.0, position: .bottom, style: style)
            return
        }
        else
        {
            self.singleTon.firstNameShipping = self.shippingAddressArr[self.selectedRow].firstNameShipping
            self.singleTon.lastNameShipping = self.shippingAddressArr[self.selectedRow].lastNameShipping
            self.singleTon.addressShipping = self.shippingAddressArr[self.selectedRow].addressShipping
            self.singleTon.streeLine2Shipping = self.shippingAddressArr[self.selectedRow].streetLine2Shipping
            self.singleTon.emailShipping = self.shippingAddressArr[self.selectedRow].emailShipping
            self.singleTon.cityShipping = self.shippingAddressArr[self.selectedRow].cityShipping
            self.singleTon.postalCodeShipping = self.shippingAddressArr[self.selectedRow].postalCodeShipping
            self.singleTon.stateShipping = self.shippingAddressArr[self.selectedRow].stateShipping
            self.singleTon.countryShipping = self.shippingAddressArr[self.selectedRow].countryShipping
            self.singleTon.phoneNumberShipping = self.shippingAddressArr[self.selectedRow].phoneNumberShipping
            
            saveShippingDetails()
        }
    }
    
    func saveShippingDetails(){
        let parameters: [String: Any] = ["email": self.shippingAddressArr[self.selectedRow].emailShipping, "firstname": self.shippingAddressArr[self.selectedRow].firstNameShipping, "lastname": self.shippingAddressArr[self.selectedRow].lastNameShipping, "streetaddress": self.shippingAddressArr[self.selectedRow].addressShipping + ", " + self.shippingAddressArr[self.selectedRow].streetLine2Shipping, "shippingcity": self.shippingAddressArr[self.selectedRow].cityShipping, "postcode": self.shippingAddressArr[self.selectedRow].postalCodeShipping, "country": self.shippingAddressArr[self.selectedRow].countryShipping, "state": self.shippingAddressArr[self.selectedRow].stateShipping, "orderid": orderId!]
        APIHelper().post(apiUrl: GlobalConstants.APIUrls.shippingDetails, parameters: parameters as [String : AnyObject]) { (response) in
            if response["data"] != JSON.null{
                self.navigateToExistingCardPage()
            }
        }
    }
    
    static func storyboardInstance() -> ShippingAddressViewController? {
        let storyboard = UIStoryboard(name: "Cart", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "ShippingAddressViewController") as? ShippingAddressViewController
    }
}
