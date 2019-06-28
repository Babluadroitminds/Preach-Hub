//
//  NotificationDetailViewController.swift
//  Preach Hub
//
//  Created by Sajeev S L on 28/06/19.
//  Copyright © 2019 AdroitMinds. All rights reserved.
//

import UIKit
import SwiftyJSON

class NotificationDetailViewController: UIViewController {

    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgVwBanner: UIImageView!
    var notificationId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getNotificationDetail()
    }
    
    func getNotificationDetail(){
        let parameters: [String: String] = [:]
        APIHelper().get(apiUrl: String.init(format: GlobalConstants.APIUrls.getNotificationDetails, notificationId!), parameters: parameters as [String : AnyObject]) { (response) in
            if response["data"].dictionary != nil {
                self.lblTitle.text = response["data"]["title"] != JSON.null ? response["data"]["title"].string : ""
                self.lblDescription.text = response["data"]["description"] != JSON.null ? response["data"]["description"].string : ""
                let imageUrl =  response["data"]["img_thumb"] != JSON.null ? response["data"]["img_thumb"].string : ""
                let urlString = imageUrl!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                self.imgVwBanner.sd_setShowActivityIndicatorView(true)
                self.imgVwBanner.sd_setIndicatorStyle(.gray)
                self.imgVwBanner.sd_setImage(with: URL.init(string: urlString!) , placeholderImage: UIImage.init(named:"ic-placeholder.png"))
                
            }
        }
    }
    
    @IBAction func backClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    static func storyboardInstance() -> NotificationDetailViewController? {
        let storyboard = UIStoryboard(name: "Notifications", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "NotificationDetailViewController") as? NotificationDetailViewController
    }
}
