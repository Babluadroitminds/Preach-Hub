//
//  ViewCartViewController.swift
//  Preach Hub
//
//  Created by Sajeev Sasidharan on 27/05/19.
//  Copyright © 2019 AdroitMinds. All rights reserved.
//

import UIKit

class viewCartTVCell : UITableViewCell
{
 
}
class ViewCartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    @IBAction func backTapped(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "viewCartCell", for: indexPath) as! viewCartTVCell
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 170
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
    }
}
