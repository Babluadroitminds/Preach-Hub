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
    
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblCartBadgeCount: UILabel!
    var categoryPicker = UIPickerView()
    var pricePicker = UIPickerView()
    var categoryList: [DataKey] = []
    var priceArray: [String] = ["Sort Low", "Sort High"]
    var categoryId: String?
    var productList: [ProductKey] = []
    var categoryTitle: String?
    var isPastor: Bool = false
    var isChurch: Bool = false
    var parentId: String?
    
    override func viewDidLoad(){
        super.viewDidLoad()
        if isPastor || isChurch {
            productCollectionView.reloadData()
        }
        else{
            getProduct()
        }
        getCategory()
        setPickerLayout()
        categoryText.text = categoryTitle
        lblMessage.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let cartInfo = UserDefaults.standard.object(forKey: "CartDetails") as? NSData
        if let cartInfo = cartInfo {
            let cartData = (NSKeyedUnarchiver.unarchiveObject(with: cartInfo as Data) as? [[String: String]])!
            lblCartBadgeCount.text = String(cartData.count)
        }
    }
    
    func setPickerLayout(){
        self.categoryText.inputView = categoryPicker
        self.priceText.inputView = pricePicker
        
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClicked))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.didTapCancel))
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        let toolbar2 = UIToolbar();
        toolbar2.sizeToFit()
        let doneButton2 = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(priceRangedoneClicked))
        let spaceButton2 = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton2 = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.didTapPriceRangeCancel))
        toolbar2.setItems([cancelButton2,spaceButton2,doneButton2], animated: false)
        
        categoryText.inputAccessoryView = toolbar
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        priceText.inputAccessoryView = toolbar2
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
//        if pickerView == categoryPicker {
//            categoryText.text = categoryList[row].title
//            categoryId =  categoryList[row].id
//
//        }
//        else {
//            priceText.text = priceArray[row]
//        }
    }
    
    @objc func doneClicked(){
        let row = self.categoryPicker.selectedRow(inComponent: 0)
        self.categoryPicker.selectRow(row, inComponent: 0, animated: false)
        self.categoryText.text = self.categoryList[row].title
        categoryText.text = categoryList[row].title
        categoryId =  categoryList[row].id
        self.categoryText.resignFirstResponder()
        if categoryId != nil {
            getProduct()
        }
    }
    
    @objc func didTapCancel() {
        self.categoryText.resignFirstResponder()
    }
    
    @objc func priceRangedoneClicked(){
        let row = self.pricePicker.selectedRow(inComponent: 0)
        self.pricePicker.selectRow(row, inComponent: 0, animated: false)
        self.priceText.text = self.priceArray[row]
        self.priceText.resignFirstResponder()
        if row == 0 {
            productList.sort { Float($0.price)! < Float($1.price)! }
        }
        else if row == 1 {
            productList.sort { Float($0.price)! > Float($1.price)! }
        }
        productCollectionView.reloadData()
    }
    
    @objc func didTapPriceRangeCancel() {
        self.priceText.resignFirstResponder()
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
        cell.lblProductPrice.text = "$" + currentItem.price
        cell.btnAddToCart.addTarget(self, action: #selector(btnAddToCartClicked), for: .touchUpInside)
        cell.btnAddToCart.tag = indexPath.row
        let imageUrl = currentItem.thumb
        let urlString = imageUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        cell.imgVwProduct.sd_setShowActivityIndicatorView(true)
        cell.imgVwProduct.sd_setIndicatorStyle(.gray)
        cell.imgVwProduct.sd_setImage(with: URL.init(string: urlString!) , placeholderImage: UIImage.init(named:"ic-placeholder.png"))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: collectionView.frame.size.width / 2, height: 270)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
      //  self.performSegue(withIdentifier: "ToProductDetailsVC", sender: self)
    }
    
    @IBAction func categoryTapped(_ sender: Any){
        self.categoryText.becomeFirstResponder()
    }
    
    @IBAction func priceTapped(_ sender: Any){
        self.priceText.becomeFirstResponder()
    }
    
    @objc func btnAddToCartClicked(sender : UIButton){
        navigateToProductDetailsPage(index: sender.tag)
    }
    
    func getCategory(){
        
        let parameters: [String: String] = [:]
        let dict = ["where": ["parentid": parentId]] as [String : Any]
        
        if let json = try? JSONSerialization.data(withJSONObject: dict, options: []) {
            if let content = String(data: json, encoding: String.Encoding.utf8) {
                var url = ""
                if isPastor || isChurch {
                    url = String.init(format: GlobalConstants.APIUrls.getCategoryByParentId,content)
                }
                else{
                    url = GlobalConstants.APIUrls.getCategory
                }
                APIHelper().get(apiUrl: url, parameters: parameters as [String : AnyObject]) { (response) in
                    self.categoryList.append(DataKey(id: "", title: "All", thumb: "", description: "", isActive: false, videoUrl: "", subtitle: "", tags: "", isContinueWatching: false, audioUrl: ""))
                    if response["data"].array != nil  {
                        for item in response["data"].arrayValue {
                            self.categoryList.append(DataKey(id: item["id"] != JSON.null ? item["id"].string! : "", title: item["name"] != JSON.null ? item["name"].string! : "", thumb: item["img_thumb"] != JSON.null ? item["img_thumb"].string! : "", description: item["description"] != JSON.null ? item["description"].string! : "", isActive: item["is_active"] != JSON.null ? item["is_active"].bool! : true, videoUrl: "", subtitle: "", tags: "", isContinueWatching: false, audioUrl: ""))
                        }
                        self.categoryList.sort{ $0.title.caseInsensitiveCompare($1.title) == .orderedAscending }
                        self.categoryPicker.reloadAllComponents()
                    }
                }
            }
        }
    }
    
    func getProduct(){
        let parameters: [String: String] = [:]
        var dict = ["where": [ "categoryid": categoryId]]
        if categoryText.text == "All" {
            if isPastor || isChurch {
                dict = ["where": [ "parentid": parentId]]
            }
        }

        if let json = try? JSONSerialization.data(withJSONObject: dict, options: []) {
            if var content = String(data: json, encoding: String.Encoding.utf8) {
                var url = ""
                if categoryText.text == "All"{
                    if isPastor || isChurch {
                       url = GlobalConstants.APIUrls.getAllProductsByParentId
                    }
                    else{
                        url = GlobalConstants.APIUrls.getAllProducts
                        content = ""
                    }
                }
                else {
                    url = GlobalConstants.APIUrls.getProductByCategoryId
                }
                APIHelper().get(apiUrl: String.init(format: url,content), parameters: parameters as [String : AnyObject]) { (response) in
                    self.productList = []
                    if response["data"].array != nil  {
                        for item in response["data"].arrayValue {
                            self.productList.append(ProductKey(id: item["id"] != JSON.null ? item["id"].string! : "",name:  item["name"] != JSON.null ? item["name"].string! : "",price: item["price"] != JSON.null ? item["price"].string! : "",categoryid: item["categoryid"] != JSON.null ?item["categoryid"].string! : "",thumb: item["img_thumb"] != JSON.null ? item["img_thumb"].string! : "",productcode: item["productcode"] != JSON.null ? item["productcode"].string! : "", productsize: item["productsize"] != JSON.null ? item["productsize"].string! : "", quantity: item["quantity"] != JSON.null ? item["quantity"].string! : "", colourid: item["colourid"] != JSON.null ? item["colourid"].string! : "",isActive: item["is_active"] != JSON.null ? item["is_active"].bool! : true))
                        }
                        self.productCollectionView.reloadData()
                        if response["data"].count == 0 {
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
    
    @IBAction func cartClicked(_ sender: Any) {
        let viewCartVC = ViewCartViewController.storyboardInstance()
        self.navigationController?.pushViewController(viewCartVC!, animated: true)
    }
    
    func navigateToProductDetailsPage(index: Int){
        let ProductDetailsVC = ProductDetailsViewController.storyboardInstance()
        ProductDetailsVC!.productList = [productList[index]]
        self.navigationController?.pushViewController(ProductDetailsVC!, animated: true)
    }
    
    @IBAction func backClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    static func storyboardInstance() -> ProductViewController? {
        let storyboard = UIStoryboard(name: "Cart", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "ProductViewController") as? ProductViewController
    }
}
