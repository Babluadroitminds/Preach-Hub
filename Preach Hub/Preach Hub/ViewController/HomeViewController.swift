//
//  HomeViewController.swift
//  Preach Hub
//
//  Created by Adroitminds on 17/05/19.
//  Copyright © 2019 AdroitMinds. All rights reserved.
//

import UIKit
import SideMenu

class tableViewCell : UITableViewCell , UICollectionViewDelegate , UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    let topImageArray = ["minister_mukhubatwo.png","minister_muligwe.png","minister_paul.png","minister_masekona.png","minister_mauna.png"]
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! collectionViewCell
        if indexPath.row == 0 {
            cell.lblName.text = "davdgasvdha"
            cell.imgView?.image = UIImage(named: topImageArray[indexPath.row])
        }
        else {
            cell.lblName.text = "Churches"
            cell.imgView?.image = UIImage(named: topImageArray[indexPath.row])
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 3.2, height: 110)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        let currentCell = collectionView.cellForItem(at: indexPath) as! collectionViewCell
        let selctedView = UIView()
        selctedView.backgroundColor = UIColor.clear
        currentCell.selectedBackgroundView? = selctedView
        
    }
    @IBAction func btnMoreAction(_ sender: Any) {
        //        self.navigateToPastorScreenPage()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MoreClickEventNotification"), object: nil)
        
    }
    
}

class tableHeaderCell: UITableViewCell, UICollectionViewDelegate , UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {   //top cell
    
    @IBOutlet weak var pagerControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    override func awakeFromNib() {
        pagerControl.currentPage = 0
        pagerControl.numberOfPages = 5
        collectionView.isPagingEnabled = true
    }
    let topImageArray = ["minister_mukhubatwo.png","minister_muligwe.png","minister_paul.png","minister_masekona.png","minister_mauna.png"]
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeaderCell", for: indexPath) as! collectionHeaderCell
        cell.imgView?.image = UIImage(named: topImageArray[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height )
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        let currentCell = collectionView.cellForItem(at: indexPath) as! collectionHeaderCell
        let selctedView = UIView()
        selctedView.backgroundColor = UIColor.clear
        currentCell.selectedBackgroundView? = selctedView
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()
        
        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size
        
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        guard let indexPath = collectionView.indexPathForItem(at: visiblePoint) else { return }
        pagerControl.currentPage = Int(indexPath.row)
    }}
class collectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
}
class collectionHeaderCell: UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    
}

class HomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.MoreToCall), name: NSNotification.Name(rawValue: "MoreClickEventNotification"), object: nil)
        
        //SideMenuManager.MenuPresentMode = .viewSlideOut
    }
    @objc func MoreToCall() {
        self.navigateToPastorScreenPage()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tblView.dequeueReusableCell(withIdentifier: "HeaderTableCell", for: indexPath) as! tableHeaderCell
            return cell
        }
        let cell = tblView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! tableViewCell
        //        let selctedView = UIView()
        //        selctedView.backgroundColor = UIColor.clear
        //        cell.selectedBackgroundView? = selctedView
        if indexPath.row == 1 {
            cell.lblHeader.text = "Continue Watching"
        }
        else   if indexPath.row == 2 {
            cell.lblHeader.text = "Churches"
        }
        else   if indexPath.row == 3 {
            cell.lblHeader.text = "Church Ministry Channel"
        }
        else   if indexPath.row == 4 {
            cell.lblHeader.text = "Store"
        }
        else {
            cell.lblHeader.text = "Gospel Music"
        }
        cell.backgroundColor = UIColor.clear
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row == 0
        {
            return 220
        }
        else
        {
            return 170
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        let currentCell = tblView.cellForRow(at: indexPath) as! tableViewCell
        let selctedView = UIView()
        selctedView.backgroundColor = UIColor.clear
        currentCell.selectedBackgroundView? = selctedView
    }
    
}

