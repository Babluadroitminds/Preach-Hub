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

struct shippingAddress
{
    var nameShipping : String
    var streetShipping : String
    var streetLine2Shipping : String
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

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        viewDot.layer.borderColor = UIColor.clear.cgColor
        viewDot.layer.borderWidth = 2.0
        viewDot.layer.cornerRadius = 9.0
        viewDot.addViewDashedBorder(view: viewDot)
        
        self.addressTableView.tableFooterView = nil
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
                self.shippingAddressArr.append(shippingAddress(nameShipping: data.value(forKey: "name") as! String, streetShipping: data.value(forKey: "street") as! String, streetLine2Shipping: data.value(forKey: "streetLine") as! String, cityShipping: data.value(forKey: "city") as! String, postalCodeShipping: data.value(forKey: "postalCode") as! String, stateShipping: data.value(forKey: "state") as! String, countryShipping: data.value(forKey: "country") as! String, phoneNumberShipping: data.value(forKey: "phoneNumber") as! String))
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
        
        cell.addressLine1.text = self.shippingAddressArr[indexPath.row].nameShipping + ", " + self.shippingAddressArr[indexPath.row].streetShipping
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
            self.singleTon.nameShipping = self.shippingAddressArr[self.selectedRow].nameShipping
            self.singleTon.streetShipping = self.shippingAddressArr[self.selectedRow].streetShipping
            self.singleTon.streetLine2Shipping = self.shippingAddressArr[self.selectedRow].streetLine2Shipping
            self.singleTon.cityShipping = self.shippingAddressArr[self.selectedRow].cityShipping
            self.singleTon.postalCodeShipping = self.shippingAddressArr[self.selectedRow].postalCodeShipping
            self.singleTon.stateShipping = self.shippingAddressArr[self.selectedRow].stateShipping
            self.singleTon.countryShipping = self.shippingAddressArr[self.selectedRow].countryShipping
            self.singleTon.phoneNumberShipping = self.shippingAddressArr[self.selectedRow].phoneNumberShipping
            
            self.navigateToExistingCardPage()
        }
    }
}
