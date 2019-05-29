//
//  ShippingAddressViewController.swift
//  Preach Hub
//
//  Created by Sajeev Sasidharan on 27/05/19.
//  Copyright © 2019 AdroitMinds. All rights reserved.
//

import UIKit

class ShippingAddressTVCell : UITableViewCell
{
    @IBOutlet weak var selectedBtn: UIButton!
    @IBOutlet weak var selectedView: UIView!
}
class ShippingAddressViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var viewDot: UIView!

    @IBOutlet weak var addressTableView: UITableView!

    var selectedRow = -1
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        viewDot.layer.borderColor = UIColor.clear.cgColor
        viewDot.layer.borderWidth = 2.0
        viewDot.layer.cornerRadius = 9.0
        viewDot.addViewDashedBorder(view: viewDot)
        
        self.addressTableView.tableFooterView = nil
    }
    @IBAction func backTapped(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shippingCell", for: indexPath) as! ShippingAddressTVCell
        
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
        self.navigateToExistingCardPage()
    }
}
