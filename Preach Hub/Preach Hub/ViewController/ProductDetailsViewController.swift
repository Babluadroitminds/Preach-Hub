//
//  ProductDetailsViewController.swift
//  Preach Hub
//
//  Created by Sajeev Sasidharan on 24/05/19.
//  Copyright © 2019 AdroitMinds. All rights reserved.
//

import UIKit
import SwiftyJSON

struct productSub {
    var id : String!
    var name : String!
}

class productImagesCollectionViewCell: UICollectionViewCell{
    @IBOutlet weak var notSelectedView: UIView!
    @IBOutlet weak var fullView: UIView!
}

class ProductDetailsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIPickerViewDelegate, UIPickerViewDataSource{
    @IBOutlet weak var qtyLbl: UILabel!
    @IBOutlet weak var sizeTxt: UITextField!
    @IBOutlet weak var colorTxt: UITextField!
    @IBOutlet weak var imgVwProduct: UIImageView!
    @IBOutlet weak var lblProductDescription: UILabel!
    @IBOutlet weak var lblProductPrice: UILabel!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var productImagesCollectionView: UICollectionView!
    @IBOutlet weak var lblCartBadgeCount: UILabel!
    var selectedRow = 0
    
    var sizePicker = UIPickerView()
    var colorPicker = UIPickerView()
    var productList: [ProductKey] = []
    var productSize: [productSub] = []
    var productColor: [productSub] = []
    var cart: [[String: Any]] = []
    var productDict: [String: JSON] = [:]
    var valInt: Int = 1
    var selectedColor: String?
    var selectedSize: String?
    var cartList: [[String: String]] = []
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        self.sizeTxt.inputView = sizePicker
        self.colorTxt.inputView = colorPicker
        setPickerLayout()
        getProductById()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let cartInfo = UserDefaults.standard.object(forKey: "CartDetails") as? NSData
        if let cartInfo = cartInfo {
            let cartData = (NSKeyedUnarchiver.unarchiveObject(with: cartInfo as Data) as? [[String: String]])!
              lblCartBadgeCount.text = String(cartData.count)
        }
    }
    
    func setPickerLayout(){
        self.sizeTxt.inputView = sizePicker
        self.colorTxt.inputView = colorPicker
        
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePickerClicked))
        toolbar.setItems([doneButton], animated: false)
        
        sizeTxt.inputAccessoryView = toolbar
        sizePicker.delegate = self
        sizePicker.dataSource = self
        colorTxt.inputAccessoryView = toolbar
        colorPicker.delegate = self
        colorPicker.dataSource = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == sizePicker {
            return productSize.count
        }
        else{
            return productColor.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == sizePicker {
            return productSize[row].name
        }
        else{
            return productColor[row].name
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == sizePicker {
            sizeTxt.text = productSize[row].name
            selectedSize = productSize[row].name
        }
        else {
            colorTxt.text = productColor[row].name
            selectedColor = productColor[row].name
        }
    }
    
    @objc func donePickerClicked(){
        self.view.endEditing(true)
    }
    
    
    func getProductById() {
        let productId = productList[0].id
        let parameters: [String: String] = [:]
        let dict = ["include": ["productsizes","productcolour","category","pastorproducts"]]
        
        if let json = try? JSONSerialization.data(withJSONObject: dict, options: []) {
            if let content = String(data: json, encoding: String.Encoding.utf8) {
                APIHelper().get(apiUrl: String.init(format: GlobalConstants.APIUrls.getProductById,productId,content), parameters: parameters as [String : AnyObject]) { (response) in
                    if response["data"].dictionary != nil  {
                        self.productDict = response["data"].dictionary!
                        self.lblProductName.text = self.productDict["name"]?.string
                        self.lblProductPrice.text = "$" + self.productDict["price"]!.string!
                        self.lblProductDescription.text = self.productDict["description"]!.string
                        
                        let imageUrl = response["data"]["img_thumb"].string
                        let urlString = imageUrl!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                        self.imgVwProduct.sd_setShowActivityIndicatorView(true)
                        self.imgVwProduct.sd_setIndicatorStyle(.gray)
                        self.imgVwProduct.sd_setImage(with: URL.init(string: urlString!) , placeholderImage: UIImage.init(named:""))
                        
                        self.productSize.append(productSub(id: self.productDict["productsizes"]!["id"] != JSON.null ? self.productDict["productsizes"]!["id"].string : "", name: self.productDict["productsizes"]!["name"] != JSON.null ? self.productDict["productsizes"]!["name"].string : ""))
                        
                        self.productColor.append(productSub(id: self.productDict["productcolour"]!["id"] != JSON.null ? self.productDict["productcolour"]!["id"].string : "", name: self.productDict["productcolour"]!["name"] != JSON.null ? self.productDict["productcolour"]!["name"].string : ""))
                        
                        self.sizePicker.reloadAllComponents()
                        self.colorPicker.reloadAllComponents()
                    }
                }
            }
        }
        
    }

    
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imagesCell", for: indexPath) as! productImagesCollectionViewCell
        
        cell.fullView.borderWidth = 1.0
        
        if self.selectedRow == indexPath.row{
            cell.fullView.borderColor = UIColor.red
            cell.notSelectedView.isHidden = true
        }
        else{
            cell.fullView.borderColor = UIColor.lightGray
            cell.notSelectedView.isHidden = false
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: collectionView.frame.size.width / 5, height: 47)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        self.selectedRow = indexPath.row
        self.productImagesCollectionView.reloadData()
    }
    
    @IBAction func backTapped(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func colorTapped(_ sender: Any){
        self.colorTxt.becomeFirstResponder()
    }
    
    @IBAction func sizeTapped(_ sender: Any){
        self.sizeTxt.becomeFirstResponder()
    }
    
    @IBAction func quantityIncreaseTapped(_ sender: Any){
        let val = qtyLbl.text?.replacingOccurrences(of: "Qty ", with: "")
        valInt = Int(val!)! + 1
        qtyLbl.text = "Qty " + valInt.description
    }

    @IBAction func quantityDecreaseTapped(_ sender: Any){
        if qtyLbl.text != "Qty 1"
        {
            let val = qtyLbl.text?.replacingOccurrences(of: "Qty ", with: "")
            valInt = Int(val!)! - 1
            qtyLbl.text = "Qty " + valInt.description
        }
    }
    
    @IBAction func addToCartClicked(_ sender: Any) {
        if selectedColor == nil || selectedSize == nil {
          self.view.makeToast("Please select size & color.", duration: 3.0, position: .bottom)
          return
        }
        var isAlreadyAdded: Bool = false
        
        let cartInfo = UserDefaults.standard.object(forKey: "CartDetails") as? NSData
        if let cartInfo = cartInfo {
            cartList = (NSKeyedUnarchiver.unarchiveObject(with: cartInfo as Data) as? [[String: String]])!
        }
        for (index, item) in cartList.enumerated() {
            // check for already existing item
            if item["id"] == (self.productDict["id"]?.string)!  && item["color"] == selectedColor && item["size"] == selectedSize{
                isAlreadyAdded = true
                let quantityTotal = valInt + Int((item["quantity"])!)!
                self.cartList[index]["quantity"] = quantityTotal.description
            }
        }
        
        if isAlreadyAdded == false{
            cartList.append(["id": productDict["id"] != JSON.null ? (productDict["id"]?.string)! : "","name": productDict["name"] != JSON.null ? (productDict["name"]?.string)! : "","img_thumb": productDict["img_thumb"] != JSON.null ? (productDict["img_thumb"]?.string!)! : "", "price": (productDict["price"]?.string)!, "quantity": valInt.description, "color": selectedColor!, "size": selectedSize!])
        }
        
        let productData = NSKeyedArchiver.archivedData(withRootObject: cartList)
        UserDefaults.standard.set(productData, forKey: "CartDetails")
        let viewCartVC = ViewCartViewController.storyboardInstance()
        self.navigationController?.pushViewController(viewCartVC!, animated: true)
    }
    
    static func storyboardInstance() -> ProductDetailsViewController? {
        let storyboard = UIStoryboard(name: "Cart", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "ProductDetailsViewController") as? ProductDetailsViewController
    }
    
}
