//
//  AllPastorsViewController.swift
//  Preach Hub
//
//  Created by Adroitminds on 20/05/19.
//  Copyright © 2019 AdroitMinds. All rights reserved.
//

import UIKit
import SwiftyJSON
import AVKit

struct listPastor {
    var name : String!
    var imageName : String!
}
class PastorListCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgVwPlay: UIImageView!
    @IBOutlet weak var imgView: UIImageView!
}

class ListViewController: UIViewController,UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var dataList: [DataKey] = []
    var listPastorArray = [listPastor]()
    var header: String?
    var isAllPastors: Bool = false
    var player: AVPlayer?
    var selectedContinueWatchingId: String = ""
    
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
        cell.imgView.sd_setImage(with: URL.init(string: urlString!) , placeholderImage: UIImage.init(named:"ic-placeholder.png"))
        
        if currentItem.isContinueWatching {
            cell.imgVwPlay.isHidden = false
        }
        else{
            cell.imgVwPlay.isHidden = true
        }
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
        else if(header == "CONTINUE WATCHING"){
            playVideo(videoUrl: dataList[indexPath.row].videoUrl)
            selectedContinueWatchingId = dataList[indexPath.row].id
            if dataList[indexPath.row].videoUrl != "" {
                player?.actionAtItemEnd = .none
                NotificationCenter.default.addObserver(self,selector: #selector(playerItemDidReachEnd(notification:)),name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
            }
        }
        else if(header == "GOSPEL MUSIC"){
            //playVideo(videoUrl: dataList[indexPath.row].audioUrl)
            let musicItem = dataList[indexPath.row]
            self.getMusicDetails(id: dataList[indexPath.row].id, musicItem: musicItem)
        }
    }
    
    @objc func playerItemDidReachEnd(notification: Notification) {
        if selectedContinueWatchingId != "" {
            removeContinueWatchingVideo(id: selectedContinueWatchingId)
        }
    }
    
    func removeContinueWatchingVideo(id: String){
        let parameters: [String: String] = [:]
        
        APIHelper().deleteBackground(apiUrl: String.init(format: GlobalConstants.APIUrls.removeContinueWatchingVideo, id), parameters: parameters as [String : AnyObject]) { (response) in
            
            if response["data"]["count"].int == 1 {
                self.getContinueWatchings()
            }
        }
    }
    
    func getMusicDetails(id : String, musicItem: DataKey){
        let parameters: [String: String] = [:]
        let dict = ["where": ["albumid": id] ] as [String : Any]
        
        if let json = try? JSONSerialization.data(withJSONObject: dict, options: []) {
            if let content = String(data: json, encoding: String.Encoding.utf8) {
                APIHelper().get(apiUrl: String.init(format: GlobalConstants.APIUrls.getMusic, content), parameters: parameters as [String : AnyObject]) { (response) in
                
                    if response["data"].array != nil{
                        let detailsDict = ["id": id, "name": musicItem.title, "img_thumb": musicItem.thumb]
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Music", bundle:nil)
                        let vc = storyBoard.instantiateViewController(withIdentifier: "MusicDetailsViewController") as! MusicDetailsViewController
                        vc.trackJSON = response
                        vc.musicDetailsDict = detailsDict
                        vc.isFromHome = false
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
        }
    }
    
    func getContinueWatchings(){
        let parameters: [String: String] = [:]
        let memberId = UserDefaults.standard.value(forKey: "memberId") as? String
        let dict = ["where": [ "memberid": memberId], "include": ["sermon"]] as [String : Any]
        
        if let json = try? JSONSerialization.data(withJSONObject: dict, options: []) {
            if let content = String(data: json, encoding: String.Encoding.utf8) {
                APIHelper().getBackground(apiUrl: String.init(format: GlobalConstants.APIUrls.getContinueWatchings,content), parameters: parameters as [String : AnyObject]) { (response) in
                    
                    print("responseContinue : ", response)
                    
                    self.dataList = []
                    if response["data"].array != nil  {
                        for item in response["data"].arrayValue {
                            self.dataList.append(DataKey(id: item["id"] != JSON.null ? item["id"].string! : "", title: item["sermon"]["name"] != JSON.null ? item["sermon"]["name"].string! : "", thumb: item["sermon"]["img_thumb"] != JSON.null ? item["sermon"]["img_thumb"].string! : "", description: item["sermon"]["description"] != JSON.null ? item["sermon"]["description"].string! : "", isActive: item["sermon"]["is_active"] != JSON.null ? item["sermon"]["is_active"].bool! : false, videoUrl: item["sermon"]["video"] != JSON.null ? item["sermon"]["video"].string! : "", subtitle: "", tags: "", isContinueWatching: true, audioUrl: ""))
                        }
                        self.collectionView.reloadData()
                    }
                }
            }
        }
    }
    
    func playVideo(videoUrl: String){
        let videoURL = URL(string: videoUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        if videoURL != nil {
            let player = AVPlayer(url: videoURL!)
            let vc = AVPlayerViewController()
            vc.player = player
            self.present(vc, animated: true) {
                
                try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
                vc.player?.play()
            }
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
        self.navigateToHomeScreenPage()
    }
    
    static func storyboardInstance() -> ListViewController? {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "ListViewController") as? ListViewController
    }
}
