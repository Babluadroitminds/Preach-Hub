//
//  RootViewController.swift
//  Preach Hub
//
//  Created by Adroitminds on 20/05/19.
//  Copyright © 2019 AdroitMinds. All rights reserved.
//

import UIKit

class MenuTableViewCell : UITableViewCell{
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
}

class RootViewController: UIViewController, UITabBarDelegate , UITableViewDataSource {
    @IBOutlet weak var tblView: UITableView!
    let menuItem = ["About us","Rate this app","Visit the website"]
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItem.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuTableViewCell
        cell.lblName.text = menuItem[indexPath.row]
        return cell
        
    }
}
