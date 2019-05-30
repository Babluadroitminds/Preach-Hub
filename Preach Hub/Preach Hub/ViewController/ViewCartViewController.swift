//
//  ViewCartViewController.swift
//  Preach Hub
//
//  Created by Sajeev Sasidharan on 27/05/19.
//  Copyright © 2019 AdroitMinds. All rights reserved.
//

import UIKit
import SwiftyJSON

class viewCartTVCell : UITableViewCell{
    @IBOutlet weak var minusBtn: UIButton!
    @IBOutlet weak var quantityLbl: UILabel!
    @IBOutlet weak var plusBtn: UIButton!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var imgVwProduct: UIImageView!
    @IBOutlet weak var btnDeleteProduct: UIButton!
}

class ViewCartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var BillingDetailsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var vwBillingDetails: UIView!
    @IBOutlet weak var lblSubTotalText: UILabel!
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var lblShippingAmount: UILabel!
    @IBOutlet weak var lblSubtotal: UILabel!
    @IBOutlet weak var productsTableView: UITableView!
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    var val = 1
    var cartList: [[String: String]] = []
    
    override func viewDidLoad(){
        super.viewDidLoad()
        lblMessage.isHidden = true
        self.productsTableView.tableFooterView = UIView()
        let cartInfo = UserDefaults.standard.object(forKey: "CartDetails") as? NSData
        if let cartInfo = cartInfo {
            cartList = (NSKeyedUnarchiver.unarchiveObject(with: cartInfo as Data) as? [[String: String]])!
        }
        calculateBill()
    }
    
    @IBAction func backTapped(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return cartList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "viewCartCell", for: indexPath) as! viewCartTVCell
        
        cell.minusBtn.tag = indexPath.row
        cell.plusBtn.tag = indexPath.row
        let currentItem = cartList[indexPath.row]
        cell.lblProductName.text = currentItem["name"]
        cell.lblPrice.text = "$" + (currentItem["price"])!
        cell.btnDeleteProduct.addTarget(self, action: #selector(btnDeleteProductFromCart), for: .touchUpInside)
        cell.btnDeleteProduct.tag = indexPath.row
        cell.quantityLbl.text = currentItem["quantity"]
        let imageUrl = currentItem["img_thumb"]
        let urlString = imageUrl!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        cell.imgVwProduct.sd_setShowActivityIndicatorView(true)
        cell.imgVwProduct.sd_setIndicatorStyle(.gray)
        cell.imgVwProduct.sd_setImage(with: URL.init(string: urlString!) , placeholderImage: UIImage.init(named:""))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 130
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
    }
    
    @objc func btnDeleteProductFromCart(sender: UIButton) {
        self.cartList.remove(at: sender.tag)
        self.productsTableView.reloadData()
        calculateBill()
    }
    
    @IBAction func minusTapped(_ sender: UIButton){
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let cell = self.productsTableView.cellForRow(at: indexPath) as? viewCartTVCell
        
        if cell?.quantityLbl.text != "1"{
            val = Int((cell?.quantityLbl.text)!)! - 1
            self.cartList[sender.tag]["quantity"] = val.description
            cell?.quantityLbl.text = val.description
        }
        calculateBill()
    }
    
    @IBAction func plusTapped(_ sender: UIButton){
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let cell = self.productsTableView.cellForRow(at: indexPath) as? viewCartTVCell
        
        val = Int((cell?.quantityLbl.text)!)! + 1
        self.cartList[sender.tag]["quantity"] = val.description
        cell?.quantityLbl.text = val.description
        calculateBill()
    }
    
    func calculateBill(){
        BillingDetailsHeightConstraint.constant = 200
        lblMessage.isHidden = true
        var cartList = self.cartList
        let shippingAmount: Int = 0
        var sum: Int = 0
        for item in cartList {
           // let productData =  item["productData"] as! [String: JSON]
            sum = (sum + (Int((item["quantity"]!))! * Int((item["price"])!)!))
        }

        lblSubtotal.text = "$" + sum.description
        lblShippingAmount.text = "$" + shippingAmount.description
        lblTotalAmount.text = "$" + String(sum + shippingAmount)
        
        let itemCount = cartList.count
        if itemCount == 0 {
            BillingDetailsHeightConstraint.constant = 0
            vwBillingDetails.isHidden = true
            lblMessage.isHidden = false
            cartList = []
        }
        else if itemCount == 1 {
            lblSubTotalText.text = "Subtotal(\(itemCount) item)"
        }
        else{
            lblSubTotalText.text = "Subtotal(\(itemCount) items)"
        }
        
        let productData = NSKeyedArchiver.archivedData(withRootObject: cartList)
        UserDefaults.standard.set(productData, forKey: "CartDetails")
    }
    
    static func storyboardInstance() -> ViewCartViewController? {
        let storyboard = UIStoryboard(name: "Cart", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "ViewCartViewController") as? ViewCartViewController
    }
}
