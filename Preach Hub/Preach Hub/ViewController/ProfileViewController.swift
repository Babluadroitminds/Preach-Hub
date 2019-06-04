//
//  ProfileViewController.swift
//  Preach Hub
//
//  Created by Sajeev S L on 04/06/19.
//  Copyright © 2019 AdroitMinds. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var imgVwOrder: UIImageView!
    @IBOutlet weak var imgVwFavourite: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }
    
    func setLayout(){
        imgVwOrder.layer.cornerRadius = imgVwOrder.frame.size.width / 2
        imgVwOrder.clipsToBounds = true
        imgVwFavourite.layer.cornerRadius = imgVwFavourite.frame.size.width / 2
        imgVwOrder.clipsToBounds = true
    }
}
