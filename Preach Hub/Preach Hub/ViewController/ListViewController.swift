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
        
        if isAllPastors {
            lblHeader.text = "All Pastors"
            getAllPastors()
        }
        else{
            lblHeader.text = header
        }

    }
    
    func getAllPastors(){
        let parameters: [String: String] = [:]
        APIHelper().get(apiUrl: GlobalConstants.APIUrls.getAllPastors, parameters: parameters as [String : AnyObject]) { (response) in
            if response["data"].array != nil  {
                for item in response["data"].arrayValue {
                    let is_Active = item["is_active"] != JSON.null ? item["is_active"].int : 0
                    self.dataList.append(DataKey(id: item["id"] != JSON.null ? String(item["id"].int!) : "", title: item["name"] != JSON.null ? item["name"].string! : "", thumb: item["img_thumb"] != JSON.null ? item["img_thumb"].string! : "", description: item["description"] != JSON.null ? item["description"].string! : "", isActive: is_Active == 1 ? true : false, url: item["url"] != JSON.null ? item["url"].string! : ""))
                }
                self.collectionView.reloadData()
            }
        }
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
        else if(header == "CONTINUE WATCHING") || (header == "CHURCH MINISTRY CHANNEL") 
        {
            self.getPastorDetails(url: dataList[indexPath.row].url)
        }
    }
    func getPastorDetails(url : String)
    {
        let parameters: [String: String] = [:]
        
        let urlStr = url.replacingOccurrences(of: " ", with: "")
        print("url : ", urlStr)
        
        APIHelper().get(apiUrl: urlStr, parameters: parameters as [String : AnyObject]) { (response) in
                        
            if response["data"].dictionary != nil
            {
                let storyBoard : UIStoryboard = UIStoryboard(name: "HomeDetails", bundle:nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "HomeDetailsViewController") as! HomeDetailsViewController
                
                vc.detailsDict = response["data"].dictionary!
                self.navigationController?.pushViewController(vc, animated: true)
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
