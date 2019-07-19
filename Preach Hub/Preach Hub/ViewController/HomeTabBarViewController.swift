//
//  HomeTabBarViewController.swift
//  Preach Hub
//
//  Created by Adroitminds on 20/05/19.
//  Copyright © 2019 AdroitMinds. All rights reserved.
//

import UIKit

class HomeTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarController?.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "System", size: 15)!, NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
        self.tabBarController?.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "System", size: 15)!, NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeTabBarViewController.refreshToSelectBarItem), name: NSNotification.Name(rawValue: "RefreshTabBarSelection"), object: nil)
    }
    
    @objc func refreshToSelectBarItem(notification: NSNotification) {
        self.tabBarController?.selectedIndex = 1
    }

}
