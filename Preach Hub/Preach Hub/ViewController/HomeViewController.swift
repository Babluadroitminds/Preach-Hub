//
//  HomeViewController.swift
//  Preach Hub
//
//  Created by Adroitminds on 17/05/19.
//  Copyright © 2019 AdroitMinds. All rights reserved.
//

import UIKit
import SideMenu
import SwiftyJSON

struct DataKey{
    var id: String
    var title: String
    var thumb: String
    var description: String
    var isActive: Bool
    var videoUrl: String
}

protocol CustomDelegate: class {
    func didSelectItem(id: String, selectedRow : Int, categoryTitle: String)
}

class tableViewCell : UITableViewCell , UICollectionViewDelegate , UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var btnMore: UIButton!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var dataList: [DataKey] = []
    var selectedIndex : Int?
    let topImageArray = ["minister_mukhubatwo.png","minister_muligwe.png","minister_paul.png","minister_masekona.png","minister_mauna.png"]
    
    weak var delegate: CustomDelegate?
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList.count
    }
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! collectionViewCell
        let currentItem = dataList[indexPath.row]
        cell.lblName.text = currentItem.title
        let imageUrl = currentItem.thumb
        let urlString = imageUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        cell.imgView.sd_setShowActivityIndicatorView(true)
        cell.imgView.sd_setIndicatorStyle(.gray)
        cell.imgView.sd_setImage(with: URL.init(string: urlString!) , placeholderImage: UIImage.init(named:"ic-placeholder.png"))
    
        return cell
    }
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 2.07, height: 170)
    }
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        print(indexPath.row)
        let currentCell = collectionView.cellForItem(at: indexPath) as! collectionViewCell
        let selctedView = UIView()
        selctedView.backgroundColor = UIColor.clear
        currentCell.selectedBackgroundView? = selctedView

        let id = dataList[indexPath.row].id
        let title = dataList[indexPath.row].title
        delegate?.didSelectItem(id: id, selectedRow : selectedIndex!, categoryTitle: title)
    }
    
    func setCollectioViewCell(with list: [DataKey]) {
        dataList = list
        self.collectionView.reloadData()
    }
    
}

class tableHeaderCell: UITableViewCell, UICollectionViewDelegate , UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {   //top cell
    
    @IBOutlet weak var pagerControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    var pastorLists: [DataKey] = []
    
    weak var delegate: CustomDelegate?

    override func awakeFromNib() {
        pagerControl.currentPage = 0
        collectionView.isPagingEnabled = true
    }
    let topImageArray = ["minister_mukhubatwo.png","minister_muligwe.png","minister_paul.png","minister_masekona.png","minister_mauna.png"]
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pastorLists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeaderCell", for: indexPath) as! collectionHeaderCell
        let currentItem = pastorLists[indexPath.row]
        let imageUrl = currentItem.thumb
        let urlString = imageUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        cell.imgView.sd_setShowActivityIndicatorView(true)
        cell.imgView.sd_setIndicatorStyle(.gray)
        cell.imgView.sd_setImage(with: URL.init(string: urlString!) , placeholderImage: UIImage.init(named:"ic-placeholder.png"))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        let currentCell = collectionView.cellForItem(at: indexPath) as! collectionHeaderCell
        let selctedView = UIView()
        selctedView.backgroundColor = UIColor.clear
        currentCell.selectedBackgroundView? = selctedView
        
        //delegate?.didSelectItem(id: "", selectedRow : 0, categoryTitle: "")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()
        
        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size
        
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        guard let indexPath = collectionView.indexPathForItem(at: visiblePoint) else { return }
        pagerControl.currentPage = Int(indexPath.row)
    }
    
    func fillCollectionView(with list: [DataKey]) {
        pastorLists = list
        pagerControl.numberOfPages = pastorLists.count
        self.collectionView.reloadData()
    }
}

class collectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
}
class collectionHeaderCell: UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    
}

class HomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,CustomDelegate {
    
    @IBOutlet weak var tblView: UITableView!
    var churchLists: [DataKey] = []
    var pastorLists: [DataKey] = []
    var storeLists: [DataKey] = []
    var musicLists: [DataKey] = []
    var continueWatchingLists: [DataKey] = []
    var bannerList: [DataKey] = []
    
    var headingArray = ["", "CONTINUE WATCHING", "CHURCHES", "CHURCH MINISTRY CHANNEL","GOSPEL MUSIC"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tblView.dataSource = self
        //getStores()
        getHomeDetails()
        getContinueWatchings()
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.refreshRequest), name: NSNotification.Name(rawValue: "RefreshLogoutRequest"), object: nil)
    }
    
    @objc func MoreToCall() {
        self.navigateToPastorScreenPage()
    }
    
    @objc func refreshRequest(notification: NSNotification) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.navigateToLogin()
        })
    }
    
    func getHomeDetails(){
        let parameters: [String: String] = [:]
        APIHelper().get(apiUrl: GlobalConstants.APIUrls.getHomeDetails, parameters: parameters as [String : AnyObject]) { (response) in
            
                for item in response["data"]["home"]["banners"].arrayValue {
                    self.bannerList.append(DataKey(id: item["id"] != JSON.null ? item["id"].string! : "", title: item["name"] != JSON.null ? item["name"].string! : "", thumb: item["img_thumb"] != JSON.null ? item["img_thumb"].string! : "", description: item["description"] != JSON.null ? item["description"].string! : "", isActive: item["is_active"] != JSON.null ? item["is_active"].bool! : false, videoUrl: ""))
                }
            
                for item in response["data"]["home"]["pastors"].arrayValue {
                    self.pastorLists.append(DataKey(id: item["id"] != JSON.null ? item["id"].string! : "", title: item["name"] != JSON.null ? item["name"].string! : "", thumb: item["img_thumb"] != JSON.null ? item["img_thumb"].string! : "", description: item["description"] != JSON.null ? item["description"].string! : "", isActive: item["is_active"] != JSON.null ? item["is_active"].bool! : false, videoUrl: ""))
                }
                
                for item in response["data"]["home"]["churches"].arrayValue {
                    self.churchLists.append(DataKey(id: item["id"] != JSON.null ? item["id"].string! : "", title: item["name"] != JSON.null ? item["name"].string! : "", thumb: item["img_thumb"] != JSON.null ? item["img_thumb"].string! : "", description: item["description"] != JSON.null ? item["description"].string! : "", isActive: item["is_active"] != JSON.null ? item["is_active"].bool! : false, videoUrl: ""))
                }
                
                for item in response["data"]["home"]["music"].arrayValue {
                    self.musicLists.append(DataKey(id: item["id"] != JSON.null ? item["id"].string! : "", title: item["name"] != JSON.null ? item["name"].string! : "", thumb: item["img_thumb"] != JSON.null ? item["img_thumb"].string! : "", description: item["description"] != JSON.null ? item["description"].string! : "", isActive: item["is_active"] != JSON.null ? item["is_active"].bool! : false, videoUrl: ""))
                }
                self.tblView.reloadData()
        }
    }
    
    func getContinueWatchings(){
        let parameters: [String: String] = [:]
        let memberId = UserDefaults.standard.value(forKey: "memberId") as? String
        let dict = ["where": [ "memberid": memberId], "include": ["sermon"]] as [String : Any]
        
        if let json = try? JSONSerialization.data(withJSONObject: dict, options: []) {
            if let content = String(data: json, encoding: String.Encoding.utf8) {
                APIHelper().get(apiUrl: String.init(format: GlobalConstants.APIUrls.getContinueWatchings,content), parameters: parameters as [String : AnyObject]) { (response) in
                   
                    if response["data"].array != nil  {
                        for item in response["data"].arrayValue {
                           self.continueWatchingLists.append(DataKey(id: item["sermonid"] != JSON.null ? item["sermonid"].string! : "", title: item["sermon"]["name"] != JSON.null ? item["sermon"]["name"].string! : "", thumb: item["sermon"]["img_thumb"] != JSON.null ? item["sermon"]["img_thumb"].string! : "", description: item["sermon"]["description"] != JSON.null ? item["sermon"]["description"].string! : "", isActive: item["sermon"]["is_active"] != JSON.null ? item["sermon"]["is_active"].bool! : false, videoUrl: item["sermon"]["video"] != JSON.null ? item["sermon"]["video"].string! : ""))
                        }
                        self.tblView.reloadData()
                    }
                }
            }
        }
    }
    
    func getStores(){
        let parameters: [String: String] = [:]
        APIHelper().get(apiUrl: GlobalConstants.APIUrls.getCategory, parameters: parameters as [String : AnyObject]) { (response) in
            if response["data"].array != nil  {
                for item in response["data"].arrayValue {
                    self.storeLists.append(DataKey(id: item["id"] != JSON.null ? item["id"].string! : "", title: item["name"] != JSON.null ? item["name"].string! : "", thumb: item["img_thumb"] != JSON.null ? item["img_thumb"].string! : "", description: item["description"] != JSON.null ? item["description"].string! : "", isActive: item["is_active"] != JSON.null ? item["is_active"].bool! : true, videoUrl: ""))
                }
                self.tblView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tblView.dequeueReusableCell(withIdentifier: "HeaderTableCell", for: indexPath) as! tableHeaderCell
            cell.fillCollectionView(with: bannerList)
            
            cell.delegate = self

            return cell
        }
        let cell = tblView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! tableViewCell
        cell.btnMore.addTarget(self, action: #selector(btnMoreClicked), for: .touchUpInside)
        cell.lblHeader.text = headingArray[indexPath.row]
        
        cell.selectedIndex = indexPath.row
        if indexPath.row == 1 {
            cell.setCollectioViewCell(with: continueWatchingLists)
            cell.btnMore.tag = 1
            if continueWatchingLists.count == 0 {
                cell.lblMessage.isHidden = false
            }
            else {
                cell.lblMessage.isHidden = true
            }
        }
        else if indexPath.row == 2 {
            cell.setCollectioViewCell(with: churchLists)
            cell.btnMore.tag = 2
            if churchLists.count == 0 {
                cell.lblMessage.isHidden = false
            }
            else {
                cell.lblMessage.isHidden = true
            }
        }
        else if indexPath.row == 3 {
            cell.setCollectioViewCell(with: pastorLists)
            cell.btnMore.tag = 3
            if pastorLists.count == 0 {
                cell.lblMessage.isHidden = false
            }
            else {
                cell.lblMessage.isHidden = true
            }
        }
//        else if indexPath.row == 4 {
//            cell.setCollectioViewCell(with: storeLists)
//            cell.btnMore.tag = 4
//            if storeLists.count == 0 {
//                cell.lblMessage.isHidden = false
//            }
//            else {
//                cell.lblMessage.isHidden = true
//            }
//        }
        else {
            cell.setCollectioViewCell(with: musicLists)
            cell.btnMore.tag = 4
            if musicLists.count == 0 {
                cell.lblMessage.isHidden = false
            }
            else {
                cell.lblMessage.isHidden = true
            }
        }
        cell.backgroundColor = UIColor.clear
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if indexPath.row == 0
        {
            return 220
        }
        else
        {
            return 230
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        let currentCell = tblView.cellForRow(at: indexPath) as! tableViewCell
        let selctedView = UIView()
        selctedView.backgroundColor = UIColor.clear
        currentCell.selectedBackgroundView? = selctedView
    }
    
    @objc func btnMoreClicked(sender : UIButton){
        switch sender.tag {
        case 1:
            navigateToListViewPage(dataList: continueWatchingLists, tag: sender.tag)
            break
        case 2:
            navigateToListViewPage(dataList: churchLists, tag: sender.tag)
            break
        case 3:
            navigateToListViewPage(dataList: pastorLists, tag: sender.tag)
            break
//        case 4:
//            navigateToListViewPage(dataList: storeLists, tag: sender.tag)
//            break
        case 4:
            navigateToListViewPage(dataList: musicLists, tag: sender.tag)
            break
        default:
            break
        }
        
    }
    
    func navigateToListViewPage(dataList: [DataKey], tag: Int)
    {
        let listVC = ListViewController.storyboardInstance()
        listVC!.dataList = dataList
        listVC!.header = headingArray[tag]
        self.navigationController?.pushViewController(listVC!, animated: true)
    }
    
    func didSelectItem(id: String, selectedRow: Int, categoryTitle: String)
    {
//        if selectedRow == 4{
//            let ProductVC = ProductViewController.storyboardInstance()
//            ProductVC!.categoryId = id
//            ProductVC!.categoryTitle = categoryTitle
//            self.navigationController?.pushViewController(ProductVC!, animated: true)
//        }
//        else
        if selectedRow == 3{
            self.getPastorDetails(id : id)
        }
        else if selectedRow == 2{
            self.getChurchDetails(id: id)
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
    
    
}

extension tableViewCell: CustomDelegate
{
    func didSelectItem(id: String, selectedRow: Int, categoryTitle: String)
    {
        delegate?.didSelectItem(id: id, selectedRow: selectedRow, categoryTitle: categoryTitle)
    }
}
