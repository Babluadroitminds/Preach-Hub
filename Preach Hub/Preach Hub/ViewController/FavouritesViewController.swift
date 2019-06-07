//
//  FavouritesViewController.swift
//  Preach Hub
//
//  Created by Divya on 07/06/19.
//  Copyright © 2019 AdroitMinds. All rights reserved.
//

import UIKit

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
    var favouritesArr = [favourites]()
    
    override func viewDidLoad()
    {
        
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 2
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
        return 70
    }
}
