//
//  ViewCartViewController.swift
//  Preach Hub
//
//  Created by Sajeev Sasidharan on 27/05/19.
//  Copyright © 2019 AdroitMinds. All rights reserved.
//

import UIKit

class viewCartTVCell : UITableViewCell
{
    @IBOutlet weak var minusBtn: UIButton!
    @IBOutlet weak var quantityLbl: UILabel!
    @IBOutlet weak var plusBtn: UIButton!
    
}
class ViewCartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var productsTableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    @IBAction func backTapped(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "viewCartCell", for: indexPath) as! viewCartTVCell
        
        cell.minusBtn.tag = indexPath.row
        cell.plusBtn.tag = indexPath.row

        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 130
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
    }
    @IBAction func minusTapped(_ sender: UIButton)
    {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let cell = self.productsTableView.cellForRow(at: indexPath) as? viewCartTVCell
        
        if cell?.quantityLbl.text != "1"
        {
            let val = Int((cell?.quantityLbl.text)!)! - 1
            cell?.quantityLbl.text = val.description
        }
    }
    @IBAction func plusTapped(_ sender: UIButton)
    {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let cell = self.productsTableView.cellForRow(at: indexPath) as? viewCartTVCell
        
        let val = Int((cell?.quantityLbl.text)!)! + 1
        cell?.quantityLbl.text = val.description
    }
}
