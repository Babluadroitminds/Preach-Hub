//
//  ProductViewController.swift
//  Preach Hub
//
//  Created by Sajeev Sasidharan on 24/05/19.
//  Copyright © 2019 AdroitMinds. All rights reserved.
//

import UIKit
import SwiftyJSON

struct ProductKey{
    var id: String;
    var name: String;
    var price: String;
    var categoryid: String;
    var thumb: String;
    var productcode: String;
    var productsize: String;
    var quantity: String;
    var colourid: String;
    var isActive: Bool;
}

class productCollectionViewCell: UICollectionViewCell{
    @IBOutlet weak var sideSepLine: UIView!
    @IBOutlet weak var btnAddToCart: UIButton!
    @IBOutlet weak var lblProductPrice: UILabel!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var imgVwProduct: UIImageView!
}

class ProductViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIPickerViewDataSource, UIPickerViewDelegate{
    @IBOutlet weak var priceText: UITextField!
    @IBOutlet weak var categoryText: UITextField!
    @IBOutlet weak var productCollectionView: UICollectionView!
    
    var categoryPicker = UIPickerView()
    var pricePicker = UIPickerView()
    var categoryList: [DataKey] = []
    var priceArray: [String] = []
    var categoryId: String?
    var productList: [ProductKey] = []
    
    override func viewDidLoad(){
        super.viewDidLoad()
        getCategory()
        getProduct()
        setPickerLayout()
    }
    
    func setPickerLayout(){
        self.categoryText.inputView = categoryPicker
        self.priceText.inputView = pricePicker
        
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePickerClicked))
        toolbar.setItems([doneButton], animated: false)
        
        categoryText.inputAccessoryView = toolbar
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        priceText.inputAccessoryView = toolbar
        pricePicker.delegate = self
        pricePicker.dataSource = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == categoryPicker {
            return categoryList.count
        }
        else{
            return priceArray.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == categoryPicker {
            return categoryList[row].title
        }
        else{
            return priceArray[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == categoryPicker {
            categoryText.text = categoryList[row].title
            categoryId =  categoryList[row].id
            getProduct()
        }
        else {
            priceText.text = priceArray[row]
        }
    }
    
    @objc func donePickerClicked(){
        self.view.endEditing(true)
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return productList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as! productCollectionViewCell
        
        if indexPath.row % 2 == 0{
            cell.sideSepLine.isHidden = false
        }
        else{
            cell.sideSepLine.isHidden = true
        }
        let currentItem = productList[indexPath.row]
        cell.lblProductName.text = currentItem.name
        cell.lblProductPrice.text = currentItem.price
        let imageUrl = currentItem.thumb
        let urlString = imageUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        cell.imgVwProduct.sd_setShowActivityIndicatorView(true)
        cell.imgVwProduct.sd_setIndicatorStyle(.gray)
        cell.imgVwProduct.sd_setImage(with: URL.init(string: urlString!) , placeholderImage: UIImage.init(named:""))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: collectionView.frame.size.width / 2, height: 270)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        self.performSegue(withIdentifier: "ToProductDetailsVC", sender: self)
    }
    
    @IBAction func categoryTapped(_ sender: Any){
        self.categoryText.becomeFirstResponder()
    }
    
    @IBAction func priceTapped(_ sender: Any){
        self.priceText.becomeFirstResponder()
    }
    
    func getCategory(){
        let parameters: [String: String] = [:]
        APIHelper().get(apiUrl: GlobalConstants.APIUrls.getStores, parameters: parameters as [String : AnyObject]) { (response) in
            if response["data"].array != nil  {
                for item in response["data"].arrayValue {
                    self.categoryList.append(DataKey(id: item["id"] != JSON.null ? item["id"].string! : "", title: item["name"] != JSON.null ? item["name"].string! : "", thumb: item["img_thumb"] != JSON.null ? item["img_thumb"].string! : "", description: item["description"] != JSON.null ? item["description"].string! : "", isActive: item["is_active"] != JSON.null ? item["is_active"].bool! : true))
                }
                self.categoryPicker.reloadAllComponents()
            }
        }
    }
    
    func getProduct(){
        let parameters: [String: String] = [:]
        let dict = ["where": [ "categoryid": categoryId]]

        if let json = try? JSONSerialization.data(withJSONObject: dict, options: []) {
            if let content = String(data: json, encoding: String.Encoding.utf8) {
                APIHelper().get(apiUrl: String.init(format: GlobalConstants.APIUrls.getProduct,content), parameters: parameters as [String : AnyObject]) { (response) in
                    self.productList = []
                    if response["data"].array != nil  {
                        for item in response["data"].arrayValue {
                            self.productList.append(ProductKey(id: item["id"] != JSON.null ? item["id"].string! : "",name:  item["name"] != JSON.null ? item["name"].string! : "",price: item["price"] != JSON.null ? item["price"].string! : "",categoryid: item["categoryid"] != JSON.null ?item["categoryid"].string! : "",thumb: item["img_thumb"] != JSON.null ? item["img_thumb"].string! : "",productcode: item["productcode"] != JSON.null ? item["productcode"].string! : "", productsize: item["productsize"] != JSON.null ? item["productsize"].string! : "", quantity: item["quantity"] != JSON.null ? item["quantity"].string! : "", colourid: item["colourid"] != JSON.null ? item["colourid"].string! : "",isActive: item["is_active"] != JSON.null ? item["is_active"].bool! : true))
                        }
                        self.productCollectionView.reloadData()
                    }
                }
            }
        }
    }
    
    @IBAction func backClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    static func storyboardInstance() -> ProductViewController? {
        let storyboard = UIStoryboard(name: "Cart", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "ProductViewController") as? ProductViewController
    }
}
