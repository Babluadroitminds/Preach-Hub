//
//  RootViewController.swift
//  Preach Hub
//
//  Created by Adroitminds on 20/05/19.
//  Copyright © 2019 AdroitMinds. All rights reserved.
//

import UIKit
import CoreData

struct MenuOption {
    var Name: String;
    var Image: String;
}

class MenuTableViewCell : UITableViewCell{
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
}

class RootViewController: UIViewController, UITabBarDelegate , UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgVwProfilePic: UIImageView!
    @IBOutlet weak var tblView: UITableView!
    var menuOptions: [MenuOption] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setMenuOptions()
        self.tblView.tableFooterView = UIView()
        setLayout()
    }
    
    func setMenuOptions(){
        menuOptions.append(MenuOption(Name: "About us", Image: "about_blue"))
        menuOptions.append(MenuOption(Name: "Rate this app", Image: "rate_blue"))
        menuOptions.append(MenuOption(Name: "Visit the website", Image: "download_blue"))
        menuOptions.append(MenuOption(Name: "Logout", Image: "logout_blue"))
        self.tblView.reloadData()
    }
    
    func setLayout(){
        lblName.text = UserDefaults.standard.string(forKey: "memberName")
        imgVwProfilePic.layer.cornerRadius = imgVwProfilePic.frame.size.width / 2
        imgVwProfilePic.clipsToBounds = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuTableViewCell
        let currentItem = menuOptions[indexPath.row]
        cell.lblName.text = currentItem.Name
        cell.imgView.image = UIImage(named: currentItem.Image)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let  currentMenu = menuOptions[indexPath.row]
        switch currentMenu.Name {
        case "About us":
            guard let url = URL(string: GlobalConstants.APIUrls.websiteLink) else { return }
            UIApplication.shared.open(url)
            break
        case "Rate this app":
            popUpInProgress()
            break
        case "Visit the website":
            guard let url = URL(string: GlobalConstants.APIUrls.websiteLink) else { return }
            UIApplication.shared.open(url)
            break
        case "Logout":
            logoutClicked()
            break
        default:
            break
        }
    }
    
    func logoutClicked(){
        let alert = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "YES", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
            
            //self.deleteCoreData()
            
            UserDefaults.standard.set(false, forKey: "Is_Logged_In")
            UserDefaults.standard.removeObject(forKey: "memberId")
            let productData = NSKeyedArchiver.archivedData(withRootObject: [])
            UserDefaults.standard.set(productData, forKey: "CartDetails")
            self.removeMemberDevice()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RefreshLogoutRequest"), object: nil)
            self.dismiss(animated: true, completion: nil)
            
        }))
        alert.addAction(UIAlertAction(title: "NO", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func removeMemberDevice(){
        let parameters: [String: String] = [:]
        let deviceId = UserDefaults.standard.value(forKey: "memberDeviceId") as? String
        if deviceId != nil {
            APIHelper().deleteBackground(apiUrl: String.init(format: GlobalConstants.APIUrls.removeMemberDevicesById, deviceId!), parameters: parameters as [String : AnyObject]) { (response) in
                UserDefaults.standard.removeObject(forKey: "memberDeviceId")
            }
        }
    }
    
    func deleteCoreData()
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CardDetails")
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
        
        self.deleteShippingAddress()
    }
    func deleteShippingAddress()
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ShippingAddress")
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
    }
}
