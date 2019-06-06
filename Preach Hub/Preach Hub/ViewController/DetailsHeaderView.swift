//
//  DetailsHeaderView.swift
//  Preach Hub
//
//  Created by Divya on 06/06/19.
//  Copyright © 2019 AdroitMinds. All rights reserved.
//

import Foundation
import UIKit

class DetailsHeaderView: UIView
{
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var middleImage: UIImageView!
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet var view : UIView!
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        xibSetUp()
    }
    
    func xibSetUp()
    {
        view = loadViewFromNib()
        view.frame = self.bounds
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView
    {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "DetailsHeaderView", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
        
    }
    @IBAction func backBtnTapped(_ sender: Any)
    {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "topBackTapped"), object: nil, userInfo: nil)
    }
}
