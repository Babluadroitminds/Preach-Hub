//
//  OrderHistoryViewController.swift
//  Preach Hub
//
//  Created by Sajeev S L on 04/06/19.
//  Copyright © 2019 AdroitMinds. All rights reserved.
//

import UIKit
import SwiftyJSON

struct OrderKey {
    var id: String;
    var orderno: String;
    var orderdate: String;
    var currencyvalue: Int;
    var paymentmethod: String
    var status: String;
}

class OrderHistoryTableViewCell : UITableViewCell{
  
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblOrderDate: UILabel!
    @IBOutlet weak var lblOrderId: UILabel!
    
    @IBOutlet weak var imgVwCancel: UIImageView!
    @IBOutlet weak var btnCancelOrder: UIButton!
    @IBOutlet weak var lblPaymentType: UILabel!
}

class OrderHistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var tableview: UITableView!
    var Orders: [OrderKey] = []
    var selectedRow: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.tableFooterView = UIView()
        self.lblMessage.isHidden = true
        getOrders()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OrderHistoryTableViewCell
        let currentItem = Orders[indexPath.row]
        cell.lblOrderId.text = "Order No: " + currentItem.orderno
        cell.lblOrderDate.text = "Order Date: " + dateString(date: currentItem.orderdate)
        cell.lblPrice.text = "$" + currentItem.currencyvalue.description
        cell.lblPaymentType.text = "Payment type: " + currentItem.paymentmethod
        cell.btnCancelOrder.addTarget(self, action: #selector(btnCancelOrderClicked), for: .touchUpInside)
        cell.btnCancelOrder.tag = indexPath.row
        if currentItem.status == "delivered"{
            cell.btnCancelOrder.isHidden = true
        }
        else {
            cell.btnCancelOrder.isHidden = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
       self.selectedRow = indexPath.row
       navigateToOrderDetailsPage()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
       return 100
    }
    
    func dateString(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat =  "MM/dd/yyyy"
        return dateFormatter.string(from: dt!)
    }
    
    func navigateToOrderDetailsPage(){
        let orderHistoryDetailsVC = OrderHistoryDetailsViewController.storyboardInstance()
        orderHistoryDetailsVC!.orderId = Orders[selectedRow!].id
        orderHistoryDetailsVC!.orderNo = Orders[selectedRow!].orderno
        orderHistoryDetailsVC!.orderStatus = Orders[selectedRow!].status
        self.navigationController?.pushViewController(orderHistoryDetailsVC!, animated: true)
    }
    
    func getOrders(){
        let memberId = UserDefaults.standard.value(forKey: "memberId") as? String
        let parameters: [String: String] = [:]
        let dict = ["where": [ "memberid": memberId], "order": ["orderdate DESC"]] as [String : Any]
        
        if let json = try? JSONSerialization.data(withJSONObject: dict, options: []) {
            if let content = String(data: json, encoding: String.Encoding.utf8) {
                APIHelper().get(apiUrl: String.init(format: GlobalConstants.APIUrls.getOrdersByMemberId,content), parameters: parameters as [String : AnyObject]) { (response) in
                    self.Orders = []
                    if response["data"].array != nil  {
                        for item in response["data"].arrayValue {
                            if item["orderstatus"].string != "pending"{
                                if item["orderstatus"].string != "cancelled" {
                                     self.Orders.append(OrderKey(id: item["id"] != JSON.null ? item["id"].string! : "", orderno: item["orderno"] != JSON.null ? item["orderno"].string! : "", orderdate: item["orderdate"] != JSON.null ? item["orderdate"].string! : "", currencyvalue: item["currencyvalue"] != JSON.null ? item["currencyvalue"].int!: 0, paymentmethod: item["paymentmethod"] != JSON.null ? item["paymentmethod"].string! : "", status: item["orderstatus"] != JSON.null ? item["orderstatus"].string!: ""))
                                }
                            }
                        }
                        self.tableview.reloadData()
                        if self.Orders.count == 0 {
                            self.lblMessage.isHidden = false
                        }
                        else{
                            self.lblMessage.isHidden = true
                        }
                    }
                    else{
                        self.lblMessage.isHidden = false
                    }
                }
            }
        }
    }
    
    @objc func btnCancelOrderClicked(sender: UIButton) {
        let alert = UIAlertController(title: "Cancel Order", message: "Do you want to cancel order?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "YES", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
            self.cancelOrder(index: sender.tag)
        }))
        alert.addAction(UIAlertAction(title: "NO", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func cancelOrder(index: Int){
        let currentOrder = self.Orders[index]
        let parameters: [String: Any] = ["orderstatus": "cancelled"]
        APIHelper().patch(apiUrl: String.init(format: GlobalConstants.APIUrls.confirmOrdersById, currentOrder.id), parameters: parameters as [String : AnyObject]) { (response) in
            if response["data"] != JSON.null{
                self.view.makeToast("Order cancelled", duration: 3.0, position: .bottom, title: nil, image: nil, completion: { (true) in
                    self.getOrders()
                })
            }
            else {
                self.view.makeToast("Oops! Something went wrong!", duration: 3.0, position: .bottom)
                return
            }
        }
    }
    
    @IBAction func backClicked(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
    }
    
    static func storyboardInstance() -> OrderHistoryViewController? {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "OrderHistoryViewController") as? OrderHistoryViewController
    }
}
