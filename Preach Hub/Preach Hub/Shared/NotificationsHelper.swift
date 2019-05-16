//
//  NotificationsHelper.swift
//  Preach Hub
//
//  Created by Sajeev S L on 16/05/19.
//  Copyright © 2019 AdroitMinds. All rights reserved.
//

import Foundation
import SVProgressHUD
import AVFoundation
import Crashlytics

class NotificationsHelper : NSObject {
    
    static func showBusyIndicator(message: String?){
        SVProgressHUD.setBackgroundColor( UIColor.clear)
        SVProgressHUD.setBorderColor(UIColor.darkGray)
        SVProgressHUD.setForegroundColor(UIColor(red: 245.0/255.0, green: 173.0/255.0, blue: 93.0/255.0, alpha: 1.0))
        SVProgressHUD.setBackgroundLayerColor(UIColor.darkGray)
        SVProgressHUD.setRingRadius(23.0)
        SVProgressHUD.setRingThickness(7.0)
        SVProgressHUD.setOffsetFromCenter(UIOffset(horizontal: 0, vertical:0))
        SVProgressHUD.show(withStatus: "")
    }
    
    static func hideBusyIndicator(){
        SVProgressHUD.dismiss()
    }
}
