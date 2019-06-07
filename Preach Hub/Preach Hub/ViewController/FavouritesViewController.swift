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

struct favourites
{
    var imageThumb: String
    var title: String
    var id : String
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
                    self.favouritesArr.append(favourites(imageThumb: data.imageStr!, title: data.name!, id: data.favId!))
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
            
            if index == 1
            {
                self.clearIndividualFavourite(index: sender.tag)
            }
        }
        
        dropDown.width = 150
        dropDown.dismissMode = .onTap
        
        dropDown.show()
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
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favourite")
        fetchRequest.returnsObjectsAsFaults = false
        
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
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favourite")
        let predicate = NSPredicate(format: "favId == %@", self.favouritesArr[index].id)
        fetchRequest.predicate = predicate
        
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
