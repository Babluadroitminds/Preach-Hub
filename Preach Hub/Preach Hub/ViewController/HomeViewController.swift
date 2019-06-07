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
    var url : String
}

protocol CustomDelegate: class {
    func didSelectItem(id: String, selectedRow : Int, url: String, categoryTitle: String)
}

class tableViewCell : UITableViewCell , UICollectionViewDelegate , UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var btnMore: UIButton!
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
        delegate?.didSelectItem(id: id, selectedRow : selectedIndex!, url: dataList[indexPath.row].url, categoryTitle: title)
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
        
        delegate?.didSelectItem(id: "", selectedRow : 0, url: pastorLists[indexPath.row].url, categoryTitle: "")
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
    
    var headingArray = ["", "CONTINUE WATCHING", "CHURCHES", "CHURCH MINISTRY CHANNEL", "STORE", "GOSPEL MUSIC"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tblView.dataSource = self
        getChurches()
        getStores()
        getDetails()
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
    
    func getChurches(){
        let parameters: [String: String] = [:]
        APIHelper().get(apiUrl: GlobalConstants.APIUrls.getChurches, parameters: parameters as [String : AnyObject]) { (response) in
            if response["data"].array != nil  {
                for item in response["data"].arrayValue {
                    self.churchLists.append(DataKey(id: item["id"] != JSON.null ? item["id"].string! : "", title: item["name"] != JSON.null ? item["name"].string! : "", thumb: item["img_thumb"] != JSON.null ? item["img_thumb"].string! : "", description: item["description"] != JSON.null ? item["description"].string! : "", isActive: item["is_active"] != JSON.null ? item["is_active"].bool! : true, url : ""))
                }
               self.tblView.reloadData()
            }
        }
    }
    
    func getStores(){
        let parameters: [String: String] = [:]
        APIHelper().get(apiUrl: GlobalConstants.APIUrls.getStores, parameters: parameters as [String : AnyObject]) { (response) in
            if response["data"].array != nil  {
                for item in response["data"].arrayValue {
                    self.storeLists.append(DataKey(id: item["id"] != JSON.null ? item["id"].string! : "", title: item["name"] != JSON.null ? item["name"].string! : "", thumb: item["img_thumb"] != JSON.null ? item["img_thumb"].string! : "", description: item["description"] != JSON.null ? item["description"].string! : "", isActive: item["is_active"] != JSON.null ? item["is_active"].bool! : true, url : ""))
                }
                self.tblView.reloadData()
            }
        }
    }
    
    func getDetails()
    {
        let parameters: [String: String] = [:]
        APIHelper().get(apiUrl: GlobalConstants.APIUrls.getPreachStatistics, parameters: parameters as [String : AnyObject]) { (response) in
            
            print("responseDetails : ", response)
            
            for item in response["data"]["musiclists"].arrayValue {
                let is_Active = item["is_active"] != JSON.null ? item["is_active"].int : 0
                self.musicLists.append(DataKey(id: item["id"] != JSON.null ? String(item["id"].int!) : "", title: item["name"] != JSON.null ? item["name"].string! : "", thumb: item["img_thumb"] != JSON.null ? item["img_thumb"].string! : "", description: item["description"] != JSON.null ? item["description"].string! : "", isActive:is_Active == 1 ? true : false, url : ""))
            }
            for item in response["data"]["pastorlists"].arrayValue
            {
                let is_Active = item["is_active"] != JSON.null ? item["is_active"].int : 0
                
                self.pastorLists.append(DataKey(id: item["id"] != JSON.null ? String(item["id"].int!) : "", title: item["name"] != JSON.null ? item["name"].string! : "", thumb: item["img_thumb"] != JSON.null ? item["img_thumb"].string! : "", description: item["description"] != JSON.null ? item["description"].string! : "", isActive:is_Active == 1 ? true : false, url: item["url"] != JSON.null ? item["url"].string! : ""))
            }
            self.tblView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tblView.dequeueReusableCell(withIdentifier: "HeaderTableCell", for: indexPath) as! tableHeaderCell
            cell.fillCollectionView(with: pastorLists)
            
            cell.delegate = self

            return cell
        }
        let cell = tblView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! tableViewCell
        cell.btnMore.addTarget(self, action: #selector(btnMoreClicked), for: .touchUpInside)
        cell.lblHeader.text = headingArray[indexPath.row]
        
        cell.selectedIndex = indexPath.row
        if indexPath.row == 1 {
            cell.setCollectioViewCell(with: pastorLists)
            cell.btnMore.tag = 1
        }
        else if indexPath.row == 2 {
            cell.setCollectioViewCell(with: churchLists)
            cell.btnMore.tag = 2
        }
        else if indexPath.row == 3 {
            cell.setCollectioViewCell(with: pastorLists)
            cell.btnMore.tag = 3
        }
        else if indexPath.row == 4 {
            cell.setCollectioViewCell(with: storeLists)
            cell.btnMore.tag = 4
        }
        else {
            cell.setCollectioViewCell(with: musicLists)
            cell.btnMore.tag = 5
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
            navigateToListViewPage(dataList: [], tag: sender.tag, isAllPastors: true)
            break
        case 2:
            navigateToListViewPage(dataList: churchLists, tag: sender.tag, isAllPastors: false)
            break
        case 3:
            navigateToListViewPage(dataList: [], tag: sender.tag, isAllPastors: true)
            break
        case 4:
            navigateToListViewPage(dataList: storeLists, tag: sender.tag, isAllPastors: false)
            break
        case 5:
            navigateToListViewPage(dataList: musicLists, tag: sender.tag, isAllPastors: false)
            break
        default:
            break
        }
        
    }
    
    func navigateToListViewPage(dataList: [DataKey], tag: Int, isAllPastors: Bool)
    {
        let listVC = ListViewController.storyboardInstance()
        listVC!.dataList = dataList
        listVC!.header = headingArray[tag]
        listVC!.isAllPastors = isAllPastors
        self.navigationController?.pushViewController(listVC!, animated: true)
    }
    
    func didSelectItem(id: String, selectedRow: Int, url: String, categoryTitle: String)
    {
        if selectedRow == 4
        {
            let ProductVC = ProductViewController.storyboardInstance()
            ProductVC!.categoryId = id
            ProductVC!.categoryTitle = categoryTitle
            self.navigationController?.pushViewController(ProductVC!, animated: true)
        }
        else if selectedRow == 0 || selectedRow == 1 || selectedRow == 3
        {
            self.getPastorDetails(url : url)
        }
    }
    func getPastorDetails(url : String)
    {
        let parameters: [String: String] = [:]
        
        let urlStr = url.replacingOccurrences(of: " ", with: "")
        print("url : ", urlStr)
        
        APIHelper().get(apiUrl: urlStr, parameters: parameters as [String : AnyObject]) { (response) in
            
            print("responsePastorDetails : ", response)
            
            if response["data"].dictionary != nil
            {
                let storyBoard : UIStoryboard = UIStoryboard(name: "HomeDetails", bundle:nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "HomeDetailsViewController") as! HomeDetailsViewController
                
                vc.detailsDict = response["data"].dictionary!
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

extension tableViewCell: CustomDelegate
{
    func didSelectItem(id: String, selectedRow: Int, url: String, categoryTitle: String)
    {
        delegate?.didSelectItem(id: id, selectedRow: selectedRow, url: url, categoryTitle: categoryTitle)
    }
}
