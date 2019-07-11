//
//  NotificationsTableViewCell.swift
//  Preach Hub
//
//  Created by Sajeev S L on 28/06/19.
//  Copyright © 2019 AdroitMinds. All rights reserved.
//

import UIKit

class NotificationsTableViewCell: UITableViewCell {

    @IBOutlet weak var btnReadMore: UIButton!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var imgVwThumb: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
