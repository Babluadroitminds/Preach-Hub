//
//  RootViewController.swift
//  Preach Hub
//
//  Created by Adroitminds on 20/05/19.
//  Copyright © 2019 AdroitMinds. All rights reserved.
//

import UIKit

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
        menuOptions.append(MenuOption(Name: "About us", Image: "ic-aboutus"))
        menuOptions.append(MenuOption(Name: "Rate this app", Image: "ic-rate"))
        menuOptions.append(MenuOption(Name: "Visit this apps", Image: "ic-visit"))
        menuOptions.append(MenuOption(Name: "Logout", Image: "ic-logout"))
        self.tblView.reloadData()
    }
    
    func setLayout(){
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
            popUpInProgress()
            break
        case "Rate this app":
            popUpInProgress()
            break
        case "Visit this apps":
            popUpInProgress()
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
            
            UserDefaults.standard.set(false, forKey: "Is_Logged_In")
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                self.navigateToLogin()
            })
            
        }))
        alert.addAction(UIAlertAction(title: "NO", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
