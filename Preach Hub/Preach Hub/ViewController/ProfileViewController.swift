//
//  ProfileViewController.swift
//  Preach Hub
//
//  Created by Sajeev S L on 04/06/19.
//  Copyright © 2019 AdroitMinds. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lblMemberName: UILabel!
    var profileOptions: [MenuOption] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        lblMemberName.text = UserDefaults.standard.string(forKey: "memberName")
    }
    
    @IBAction func favouriteTapped(_ sender: Any)
    {
        self.navigateToFavouritesPage()
    }
    
    func setLayout(){
        profileOptions.append(MenuOption(Name: "My Profile", Image: "ic-profile-round"))
        profileOptions.append(MenuOption(Name: "Favourite", Image: "ic-fav"))
        profileOptions.append(MenuOption(Name: "Order History", Image: "ic-order"))
         profileOptions.append(MenuOption(Name: "Notifications", Image: "ic-notification"))
        self.tblView.tableFooterView = UIView()
        self.tblView.dataSource = self
        self.tblView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProfileTableViewCell
        let currentItem = profileOptions[indexPath.row]
        cell.lblTitle.text = currentItem.Name
        cell.imgVw.image = UIImage(named: currentItem.Image)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let  currentMenu = profileOptions[indexPath.row]
        switch currentMenu.Name {
        case "Favourite":
            self.navigateToFavouritesPage()
            break
        case "Order History":
            let orderHistoryVC = OrderHistoryViewController.storyboardInstance()
            self.navigationController?.pushViewController(orderHistoryVC!, animated: true)
            break
        case "My Profile":
            let profileDetailsVC = ProfileDetailsViewController.storyboardInstance()
            self.navigationController?.pushViewController(profileDetailsVC!, animated: true)
            break
        case "Notifications":
            let notificationsViewController = NotificationsViewController.storyboardInstance()
            self.navigationController?.pushViewController(notificationsViewController!, animated: true)
            break
        default:
            break
        }
    }

}


