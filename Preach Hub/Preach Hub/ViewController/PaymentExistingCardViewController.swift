//
//  PaymentExistingCardViewController.swift
//  Preach Hub
//
//  Created by Sajeev Sasidharan on 28/05/19.
//  Copyright © 2019 AdroitMinds. All rights reserved.
//

import UIKit
import NTMonthYearPicker

class PaymentExistingCardViewController: UIViewController
{
    @IBOutlet weak var viewDot: UIView!
    @IBOutlet weak var expDateTxt: UITextField!
    
    var datePicker = NTMonthYearPicker()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        viewDot.layer.borderColor = UIColor.clear.cgColor
        viewDot.layer.borderWidth = 2.0
        viewDot.layer.cornerRadius = 10.0
        viewDot.addViewDashedBorder(view: viewDot)
        
        self.datePicker.datePickerMode = NTMonthYearPickerModeMonthAndYear
        self.datePicker.minimumDate = Date()
        
    //    [picker addTarget:self action:@selector(onDatePicked:) forControlEvents:UIControlEventValueChanged];

        self.datePicker.addTarget(self, action: #selector(onDatePicked), for: .valueChanged)
        self.expDateTxt.inputView = self.datePicker
    }
    @objc func onDatePicked()
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/yy"
        
        let dateStr = dateFormatter.string(from: self.datePicker.date)
        
        self.expDateTxt.text = dateStr
    }
    @IBAction func backTapped(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func addNewCardTapped(_ sender: Any)
    {
        self.navigateToCartPaymentPage()
    }
    @IBAction func leftTapped(_ sender: Any)
    {
    }
    @IBAction func rightTapped(_ sender: Any)
    {
    }
}
