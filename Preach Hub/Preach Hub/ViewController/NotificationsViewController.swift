//
//  NotificationsViewController.swift
//  Preach Hub
//
//  Created by Sajeev S L on 28/06/19.
//  Copyright © 2019 AdroitMinds. All rights reserved.
//

import UIKit
import SwiftyJSON

struct NotificationsKey {
    var id: String;
    var thumb: String;
    var title: String;
    var description: String;
    var dateCreated: String;
}

class NotificationsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tblView: UITableView!
    
    @IBOutlet weak var lblMessage: UILabel!
    var notifications: [NotificationsKey] = []
    var isFromPushNotificationClick: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblView.tableFooterView = UIView()
        lblMessage.isHidden = true
        getNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(NotificationsViewController.refreshNotificationRequest), name: NSNotification.Name(rawValue: "RefreshNotifications"), object: nil)
    }
    
    @objc func refreshNotificationRequest(notification: NSNotification) {
        getNotifications()
    }
    
    func getNotifications(){
        NotificationsHelper.showBusyIndicator(message: "Please wait")
        let parameters: [String: String] = [:]
        APIHelper().getBackground(apiUrl: GlobalConstants.APIUrls.getNotifications, parameters: parameters as [String : AnyObject]) { (response) in
            self.notifications = []
            if response["data"].array != nil  {
                for item in response["data"].arrayValue {
                    self.notifications.append(NotificationsKey(id: item["id"] != JSON.null ? item["id"].string! : "", thumb: item["img_thumb"] != JSON.null ? item["img_thumb"].string! : "", title: item["title"] != JSON.null ? item["title"].string! : "", description: item["description"] != JSON.null ? item["description"].string! : "", dateCreated: item["datecreated"] != JSON.null ? item["datecreated"].string! : ""))
                }
                if self.notifications.count == 0 {
                    self.lblMessage.isHidden = false
                }
                else{
                    self.lblMessage.isHidden = true
                }
            self.tblView.reloadData()
            NotificationsHelper.hideBusyIndicator()
            }
            else{
                self.lblMessage.isHidden = false
            }
            
        }
    }
    
    func dateString(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat =  "d MMM HH:mm"
        return dateFormatter.string(from: dt!)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NotificationsTableViewCell
        let currentItem = notifications[indexPath.row]
        cell.lblTitle.text = currentItem.title
        cell.lblDescription.text = currentItem.description
        cell.selectionStyle = .none
        cell.btnReadMore.addTarget(self, action: #selector(btnReadMoreClicked), for: .touchUpInside)
        cell.btnReadMore.tag = indexPath.row
        cell.lblDateTime.text = dateString(date: currentItem.dateCreated)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 210
    }
    
    @objc func btnReadMoreClicked(sender: UIButton) {
        let notificationDetailsVC = NotificationDetailViewController.storyboardInstance()
        notificationDetailsVC!.notificationId = notifications[sender.tag].id
        self.navigationController?.pushViewController(notificationDetailsVC!, animated: true)
    }
    
    @IBAction func backClicked(_ sender: Any) {
        if isFromPushNotificationClick == true {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let storyboard:UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "HomeTabBarViewController") as! HomeTabBarViewController
            initialViewController.selectedIndex = 1
            let navigationController = UINavigationController(rootViewController: initialViewController)
            navigationController.isNavigationBarHidden = true
            appDelegate.window!.rootViewController = navigationController
        }
        else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    static func storyboardInstance() -> NotificationsViewController? {
        let storyboard = UIStoryboard(name: "Notifications", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "NotificationsViewController") as? NotificationsViewController
    }
}
