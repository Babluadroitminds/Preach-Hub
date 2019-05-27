//
//  ProductViewController.swift
//  Preach Hub
//
//  Created by Sajeev Sasidharan on 24/05/19.
//  Copyright © 2019 AdroitMinds. All rights reserved.
//

import UIKit

class productCollectionViewCell: UICollectionViewCell
{
    @IBOutlet weak var sideSepLine: UIView!    
}
class ProductViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    @IBOutlet weak var priceText: UITextField!
    @IBOutlet weak var categoryText: UITextField!
    @IBOutlet weak var productCollectionView: UICollectionView!
    
    var categoryPicker = UIPickerView()
    var pricePicker = UIPickerView()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.categoryText.inputView = categoryPicker
        
        self.priceText.inputView = pricePicker
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as! productCollectionViewCell
        
        if indexPath.row % 2 == 0
        {
            cell.sideSepLine.isHidden = false
        }
        else
        {
            cell.sideSepLine.isHidden = true
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: collectionView.frame.size.width / 2, height: 270)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        self.performSegue(withIdentifier: "ToProductDetailsVC", sender: self)
    }
    @IBAction func categoryTapped(_ sender: Any)
    {
        self.categoryText.becomeFirstResponder()
    }
    @IBAction func priceTapped(_ sender: Any)
    {
        self.priceText.becomeFirstResponder()
    }
}
