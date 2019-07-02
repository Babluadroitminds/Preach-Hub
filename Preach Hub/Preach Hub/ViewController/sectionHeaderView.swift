//
//  sectionHeaderView.swift
//  Preach Hub
//
//  Created by Divya on 20/06/19.
//  Copyright © 2019 AdroitMinds. All rights reserved.
//

import Foundation
import UIKit

class sectionHeaderView: UITableViewHeaderFooterView
{
    @IBOutlet weak var segmentControl: ScrollableSegmentedControl!
    
    @IBOutlet var view : UIView!
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        //xibSetUp()
    }
    override func awakeFromNib()
    {
//        xibSetUp()
        
        if self.segmentControl.numberOfSegments == 0
        {
            self.segmentControl.segmentStyle = .imageOnLeft
            
            self.segmentControl.underlineSelected = true
            self.segmentControl.underlineHeight = self.segmentControl.bounds.height
            
            self.segmentControl.segmentContentColor = UIColor(red: 57/255.0, green: 146/255.0, blue: 223/255.0, alpha: 1.0)
            self.segmentControl.selectedSegmentContentColor = UIColor(red: 31/255.0, green: 34/255.0, blue: 34/255.0, alpha: 1.0)
            self.segmentControl.tintColor = UIColor(red: 57/255.0, green: 146/255.0, blue: 223/255.0, alpha: 1.0)
            self.segmentControl.backgroundColor = UIColor(red: 31/255.0, green: 34/255.0, blue: 34/255.0, alpha: 1.0)
            self.segmentControl.fixedSegmentWidth = false
        }
    }
//    override init(frame: CGRect)
//    {
//        super.init(frame: frame)
//        xibSetUp()
//    }
    
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
        let nib = UINib(nibName: "sectionHeader", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UITableViewHeaderFooterView
        
    }
}
