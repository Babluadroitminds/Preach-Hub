//
//  AddBillingAddressViewController.swift
//  Preach Hub
//
//  Created by Sajeev Sasidharan on 28/05/19.
//  Copyright © 2019 AdroitMinds. All rights reserved.
//

import UIKit

class AddBillingAddressViewController: UIViewController
{
    @IBOutlet weak var txtFldAddressLane: UITextField!
    @IBOutlet weak var txtFldName: UITextField!
    @IBOutlet weak var txtFldCity: UITextField!
    @IBOutlet weak var txtFldPostalCode: UITextField!
    @IBOutlet weak var txtFldPhoneNumber: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    @IBAction func backTapped(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnSavePayAction(_ sender: Any)
    {
        navigateToExistingCardPage()
    }
}
