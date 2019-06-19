//
//  FavouritesViewController.swift
//  Preach Hub
//
//  Created by Divya on 07/06/19.
//  Copyright © 2019 AdroitMinds. All rights reserved.
//

import UIKit
import CoreData
import DropDown
import AVKit
import SwiftyJSON

struct favourites
{
    var imageThumb: String
    var title: String
    var id : String
    var video: String
    var isSermons: Bool
}

class favouritesell: UITableViewCell
{
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var sermonImage: UIImageView!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
}
class FavouritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var noFoundLbl: UILabel!
    @IBOutlet weak var favouritesTableView: UITableView!
    
    var favouritesArr = [favourites]()
    var selectedSermonsId: String?
    var player: AVPlayer?
    var memberId = UserDefaults.standard.value(forKey: "memberId") as? String
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.noFoundLbl.isHidden = true
        
        self.favouritesTableView.tableFooterView = UIView()
        self.fetchFavourites()
    }
    func fetchFavourites()
    {
        self.favouritesArr.removeAll()
        
        let userId = UserDefaults.standard.value(forKey: "memberId") as? String

        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate?.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favourite")
        let predicate = NSPredicate(format: "userId == %@", userId!)
        fetchRequest.predicate = predicate
        
        do
        {
            let fetchResults = try managedContext!.fetch(fetchRequest) as? [Favourite]
            
            if fetchResults?.count != 0
            {
                for data in fetchResults!
                {
                    self.favouritesArr.append(favourites(imageThumb: data.imageStr!, title: data.name!, id: data.favId!, video: data.video != nil ? data.video! : "", isSermons: data.isSermons))
                }
            }
            
            if self.favouritesArr.count == 0
            {
                self.noFoundLbl.isHidden = false
            }
            self.favouritesTableView.reloadData()
        }
        catch
        {
            print("coreDataFetchFail")
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.favouritesArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favouriteCell") as? favouritesell

        let imageUrl = self.favouritesArr[indexPath.row].imageThumb
        let urlString = imageUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        cell!.sermonImage.sd_setShowActivityIndicatorView(true)
        cell!.sermonImage.sd_setIndicatorStyle(.gray)
        cell!.sermonImage.sd_setImage(with: URL.init(string: urlString!) , placeholderImage: UIImage.init(named:"ic-placeholder.png"))
                    
        cell!.name.text = self.favouritesArr[indexPath.row].title
        
        cell!.moreBtn.tag = indexPath.row
        
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 85
    }
    @IBAction func backTapped(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func moreTapped(_ sender: UIButton)
    {
        let dropDown = DropDown()
        
        dropDown.anchorView = sender
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        
        dropDown.dataSource = ["Play", "Unfavourite"]
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            if index == 0 {
                let videoURL = URL(string: self.favouritesArr[sender.tag].video)
                if videoURL != nil {
                    self.player = AVPlayer(url: videoURL!)
                    let vc = AVPlayerViewController()
                    vc.player = self.player
                    
                    self.present(vc, animated: true) {
                        vc.player?.play()
                    }
                    if self.favouritesArr[sender.tag].isSermons {
                        self.selectedSermonsId = self.favouritesArr[sender.tag].id
                        self.player!.addObserver(self, forKeyPath: "rate", options: NSKeyValueObservingOptions(), context: nil)
                    }
                    else {
                        self.selectedSermonsId = ""
                    }
                }
            }
            if index == 1{
                self.clearIndividualFavourite(index: sender.tag)
            }
        }
        
        dropDown.width = 150
        dropDown.dismissMode = .onTap
        
        dropDown.show()
    }
    
    //observer for av play
    override  func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "rate" {
            if player?.timeControlStatus == .paused {
                continueWatchingsPaused()
            }
        }
    }
    
    func continueWatchingsPaused(){
        if selectedSermonsId != "" {
            let parameters: [String: String] = [:]
            let dict = ["where":["sermonid": selectedSermonsId, "memberid": memberId]] as [String : Any]
            
            if let json = try? JSONSerialization.data(withJSONObject: dict, options: []) {
                if let content = String(data: json, encoding: String.Encoding.utf8) {
                    APIHelper().getBackground(apiUrl: String.init(format: GlobalConstants.APIUrls.getContinueWatchingById, content), parameters: parameters as [String : AnyObject]) { (response) in
                        if response["data"].array!.count == 0 {
                            let param: [String: Any] = ["sermonid": self.selectedSermonsId!, "memberid": self.memberId!]
                            APIHelper().postBackground(apiUrl: GlobalConstants.APIUrls.continueWatchings, parameters: param as [String : AnyObject]) { (response) in
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RefreshHomeRequest"), object: nil)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func deallocObservers(player: AVPlayer) {
        player.removeObserver(self, forKeyPath: "rate")
    }
    @IBAction func topMoreTapped(_ sender: UIButton)
    {
        let dropDown = DropDown()
        
        dropDown.anchorView = sender
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        
        dropDown.dataSource = ["Clear all"]
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            
            let alert = UIAlertController(title: "Alert", message: "Do you want to clear favourites?", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: {action in
                
                self.clearAllFavourite()
            }
            ))
            alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
        
        dropDown.width = 150
        dropDown.dismissMode = .onTap
        
        dropDown.show()
    }
    func clearAllFavourite()
    {
        let userId = UserDefaults.standard.value(forKey: "memberId") as? String

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favourite")
        fetchRequest.returnsObjectsAsFaults = false

        let userIdKeyPredicate = NSPredicate(format: "userId == %@", userId!)
        
        let andPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [userIdKeyPredicate])
        
        fetchRequest.predicate = andPredicate
        
        do
        {
            let results = try managedContext.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Detele all data error : \(error) \(error.userInfo)")
        }
        
        self.favouritesArr.removeAll()
        self.favouritesTableView.reloadData()
        
        if self.favouritesArr.count == 0
        {
            self.noFoundLbl.isHidden = false
        }
    }
    func clearIndividualFavourite(index : Int)
    {
        let userId = UserDefaults.standard.value(forKey: "memberId") as? String

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favourite")
        
        let userIdKeyPredicate = NSPredicate(format: "userId == %@", userId!)
        let predicate = NSPredicate(format: "favId == %@", self.favouritesArr[index].id)

        let andPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [userIdKeyPredicate, predicate])
        
        fetchRequest.predicate = andPredicate
        
        do
        {
            let fetchResults = try managedContext.fetch(fetchRequest) as? [Favourite]
            
            if fetchResults?.count != 0
            {
                let managedObjectData: NSManagedObject = fetchResults![0]

                managedContext.delete(managedObjectData)
            }
        }
        catch let error as NSError
        {
            print("Detele all data error : \(error) \(error.userInfo)")
        }
        
        self.favouritesArr.remove(at: index)
        self.favouritesTableView.reloadData()
        
        if self.favouritesArr.count == 0
        {
            self.noFoundLbl.isHidden = false
        }
    }
}
