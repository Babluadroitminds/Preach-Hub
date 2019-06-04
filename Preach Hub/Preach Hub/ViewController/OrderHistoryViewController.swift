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
}

class OrderHistoryTableViewCell : UITableViewCell{
  
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblOrderDate: UILabel!
    @IBOutlet weak var lblOrderId: UILabel!
}

class OrderHistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    @IBOutlet weak var tableview: UITableView!
    var Orders: [OrderKey] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.tableFooterView = UIView()
        getOrders()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OrderHistoryTableViewCell
        let currentItem = Orders[indexPath.row]
        cell.lblOrderId.text = "Order No: " + currentItem.orderno
        cell.lblOrderDate.text = "Order Date:"
        cell.lblPrice.text = "$" + currentItem.currencyvalue.description
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
       return 90
    }
    
    func getOrders(){
        let parameters: [String: String] = [:]
        APIHelper().get(apiUrl: GlobalConstants.APIUrls.getOrders, parameters: parameters as [String : AnyObject]) { (response) in
            if response["data"].array != nil  {
                for item in response["data"].arrayValue {
                    self.Orders.append(OrderKey(id: item["id"] != JSON.null ? item["id"].string! : "", orderno: item["orderno"] != JSON.null ? item["orderno"].string! : "", orderdate: item["orderdate"] != JSON.null ? item["orderdate"].string! : "", currencyvalue: item["currencyvalue"] != JSON.null ? item["currencyvalue"].int!: 0))
                }
                self.tableview.reloadData()
            }
        }
    }
    
    @IBAction func backClicked(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
    }
    
}
