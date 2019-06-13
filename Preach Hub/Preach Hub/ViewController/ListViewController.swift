//
//  AllPastorsViewController.swift
//  Preach Hub
//
//  Created by Adroitminds on 20/05/19.
//  Copyright © 2019 AdroitMinds. All rights reserved.
//

import UIKit
import SwiftyJSON

struct listPastor {
    var name : String!
    var imageName : String!
}
class PastorListCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var imgView: UIImageView!
}

class ListViewController: UIViewController,UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var dataList: [DataKey] = []
    var listPastorArray = [listPastor]()
    var header: String?
    var isAllPastors: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         lblHeader.text = header
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PastorCell", for: indexPath) as! PastorListCollectionViewCell
        let currentItem = dataList[indexPath.row]
        cell.lblName.text = currentItem.title
        let imageUrl = currentItem.thumb
        let urlString = imageUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        cell.imgView.sd_setShowActivityIndicatorView(true)
        cell.imgView.sd_setIndicatorStyle(.gray)
        cell.imgView.sd_setImage(with: URL.init(string: urlString!) , placeholderImage: UIImage.init(named:""))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 2.07, height: 160)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if(header == "STORE")
        {
            navigateToProductPage(index: indexPath.row)
        }
        else if(header == "CHURCH MINISTRY CHANNEL")
        {
           self.getPastorDetails(id: dataList[indexPath.row].id)
        }
        else if(header == "CHURCHES") {
          self.getChurchDetails(id: dataList[indexPath.row].id)
        }
    }
    
    func getPastorDetails(id : String){
        let parameters: [String: String] = [:]
        let dict = ["include": ["pastorsermons","products","events","testimonies"]] as [String : Any]
        
        if let json = try? JSONSerialization.data(withJSONObject: dict, options: []) {
            if let content = String(data: json, encoding: String.Encoding.utf8) {
                APIHelper().get(apiUrl: String.init(format: GlobalConstants.APIUrls.getPastorDetails, id, content), parameters: parameters as [String : AnyObject]) { (response) in
                    
                    if response["data"].dictionary != nil  {
                        let storyBoard : UIStoryboard = UIStoryboard(name: "HomeDetails", bundle:nil)
                        let vc = storyBoard.instantiateViewController(withIdentifier: "HomeDetailsViewController") as! HomeDetailsViewController
                        vc.detailsDict = response["data"].dictionary!
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
        }
    }
    
    func getChurchDetails(id : String){
        let parameters: [String: String] = [:]
        let dict = ["include": ["branches","events","products","news"]] as [String : Any]
        
        if let json = try? JSONSerialization.data(withJSONObject: dict, options: []) {
            if let content = String(data: json, encoding: String.Encoding.utf8) {
                APIHelper().get(apiUrl: String.init(format: GlobalConstants.APIUrls.getChurchDetails, id, content), parameters: parameters as [String : AnyObject]) { (response) in
                    
                    if response["data"].dictionary != nil  {
                        let storyBoard : UIStoryboard = UIStoryboard(name: "ChurchDetails", bundle:nil)
                        let vc = storyBoard.instantiateViewController(withIdentifier: "ChurchDetailsViewController") as! ChurchDetailsViewController
                        vc.detailsDict = response["data"].dictionary!
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
        }
    }
    
    
    func navigateToProductPage(index: Int){
        let ProductVC = ProductViewController.storyboardInstance()
        ProductVC!.categoryId = dataList[index].id
        ProductVC!.categoryTitle = dataList[index].title
        self.navigationController?.pushViewController(ProductVC!, animated: true)
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    static func storyboardInstance() -> ListViewController? {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "ListViewController") as? ListViewController
    }
}
