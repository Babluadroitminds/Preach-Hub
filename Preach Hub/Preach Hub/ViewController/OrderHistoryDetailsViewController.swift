//
//  OrderHistoryDetailsViewController.swift
//  Preach Hub
//
//  Created by Sajeev S L on 06/06/19.
//  Copyright © 2019 AdroitMinds. All rights reserved.
//

import UIKit
import SwiftyJSON

struct OrdersDetailsKey {
    var id: String;
    var title: String;
    var price: Int;
    var quantity: Int;
    var thumb: String;
    var size: String;
    var color: String
}

class OrderHistoryDetailsTableViewCell : UITableViewCell{
    
    @IBOutlet weak var vwSize: UIView!
    @IBOutlet weak var vwColor: UIView!
    @IBOutlet weak var vwQuantity: UIView!
    @IBOutlet weak var lblSize: UITextField!
    @IBOutlet weak var lblColor: UITextField!
    @IBOutlet weak var lblQuantity: UITextField!
    @IBOutlet weak var imgVwProduct: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
}

class OrderHistoryDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var ordersDetails: [OrdersDetailsKey] = []
    var orderId : String?
    var orderNo: String?

    @IBOutlet weak var lblOrderNo: UILabel!
    @IBOutlet weak var tblvwOrders: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblOrderNo.text = "Order No: " + orderNo!
        self.tblvwOrders.tableFooterView = UIView()
        getOrderDetails()
    }
    
    func getOrderDetails(){
        let parameters: [String: String] = [:]
        let dict = ["where": [ "orderid": orderId], "include":["productsize","productcolour","product"]] as [String : Any]
        
        if let json = try? JSONSerialization.data(withJSONObject: dict, options: []) {
            if let content = String(data: json, encoding: String.Encoding.utf8) {
                APIHelper().get(apiUrl: String.init(format: GlobalConstants.APIUrls.getOrderDetailsById,orderId!,content), parameters: parameters as [String : AnyObject]) { (response) in
                    self.ordersDetails = []
                    if response["data"].array != nil  {
                        for item in response["data"].arrayValue {
                            self.ordersDetails.append(OrdersDetailsKey(id: item["id"] != JSON.null ? item["id"].string! : "", title: item["product"]["name"] != JSON.null ? item["product"]["name"].string! : "", price: item["price"] != JSON.null ? item["price"].int! : 0, quantity: item["qtyordered"] != JSON.null ? item["qtyordered"].int! : 0, thumb: item["product"]["img_thumb"] != JSON.null ? item["product"]["img_thumb"].string! : "", size: item["productsize"]["name"] != JSON.null ? item["productsize"]["name"].string! : "", color: item["productcolour"]["name"] != JSON.null ? item["productcolour"]["name"].string! : ""))
                        }
                        self.tblvwOrders.reloadData()
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ordersDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as!
        OrderHistoryDetailsTableViewCell
        let currentItem = ordersDetails[indexPath.row]
        cell.lblProductName.text = currentItem.title
        cell.lblQuantity.text = "Quantity: " + currentItem.quantity.description
        cell.lblColor.text = "Color: " + currentItem.color
        cell.lblSize.text = "Size: " + currentItem.size
        cell.lblPrice.text = "$" + currentItem.price.description
        let imageUrl = currentItem.thumb
        let urlString = imageUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        cell.imgVwProduct.sd_setShowActivityIndicatorView(true)
        cell.imgVwProduct.sd_setIndicatorStyle(.gray)
        cell.imgVwProduct.sd_setImage(with: URL.init(string: urlString!) , placeholderImage: UIImage.init(named:"ic-placeholder.png"))
        if currentItem.color == "" {
            cell.vwColor.isHidden = true
        }
        if currentItem.size == "" {
            cell.vwSize.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 305
    }
    
    @IBAction func backClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    static func storyboardInstance() -> OrderHistoryDetailsViewController? {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "OrderHistoryDetailsViewController") as? OrderHistoryDetailsViewController
    }
}
