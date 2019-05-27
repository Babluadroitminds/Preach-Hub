//
//  ProductDetailsViewController.swift
//  Preach Hub
//
//  Created by Sajeev Sasidharan on 24/05/19.
//  Copyright © 2019 AdroitMinds. All rights reserved.
//

import UIKit

class productImagesCollectionViewCell: UICollectionViewCell
{
    @IBOutlet weak var notSelectedView: UIView!
    @IBOutlet weak var fullView: UIView!
}
class ProductDetailsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    @IBOutlet weak var qtyLbl: UILabel!
    @IBOutlet weak var sizeTxt: UITextField!
    @IBOutlet weak var colorTxt: UITextField!
    
    @IBOutlet weak var productImagesCollectionView: UICollectionView!

    var selectedRow = 0
    
    var sizePicker = UIPickerView()
    var colorPicker = UIPickerView()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.sizeTxt.inputView = sizePicker
        self.colorTxt.inputView = colorPicker
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imagesCell", for: indexPath) as! productImagesCollectionViewCell
        
        cell.fullView.borderWidth = 1.0
        
        if self.selectedRow == indexPath.row
        {
            cell.fullView.borderColor = UIColor.red
            cell.notSelectedView.isHidden = true
        }
        else
        {
            cell.fullView.borderColor = UIColor.lightGray
            cell.notSelectedView.isHidden = false
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: collectionView.frame.size.width / 5, height: 47)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        self.selectedRow = indexPath.row
        self.productImagesCollectionView.reloadData()
    }
    @IBAction func backTapped(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func colorTapped(_ sender: Any)
    {
        self.colorTxt.becomeFirstResponder()
    }
    @IBAction func sizeTapped(_ sender: Any)
    {
        self.sizeTxt.becomeFirstResponder()
    }
    @IBAction func quantityIncreaseTapped(_ sender: Any)
    {
        let val = qtyLbl.text?.replacingOccurrences(of: "Qty ", with: "")
        let valInt = Int(val!)! + 1
        qtyLbl.text = "Qty " + valInt.description
    }
    @IBAction func quantityDecreaseTapped(_ sender: Any)
    {
        if qtyLbl.text != "Qty 1"
        {
            let val = qtyLbl.text?.replacingOccurrences(of: "Qty ", with: "")
            let valInt = Int(val!)! - 1
            qtyLbl.text = "Qty " + valInt.description
        }
    }
}
