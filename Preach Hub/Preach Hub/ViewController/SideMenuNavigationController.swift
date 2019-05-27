//
//  SideMenuNavigation.swift
//  Preach Hub
//
//  Created by Sajeev S L on 24/05/19.
//  Copyright © 2019 AdroitMinds. All rights reserved.
//

import UIKit
import SideMenu

class SideMenuNavigationController: UISideMenuNavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.sideMenuManager.menuPresentMode = .menuSlideIn
    }
    

}
