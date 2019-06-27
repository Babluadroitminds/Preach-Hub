//
//  ProfileTableViewCell.swift
//  Preach Hub
//
//  Created by Sajeev S L on 27/06/19.
//  Copyright © 2019 AdroitMinds. All rights reserved.
//

import UIKit



class ProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgVw: UIImageView!
    
    override func awakeFromNib() {
        imgVw.layer.cornerRadius = imgVw.frame.size.width / 2
        imgVw.clipsToBounds = true
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
