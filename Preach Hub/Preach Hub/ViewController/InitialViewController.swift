//
//  InitialViewController.swift
//  Preach Hub
//
//  Created by Sajeev S L on 16/05/19.
//  Copyright © 2019 AdroitMinds. All rights reserved.
//

import UIKit
import FSPagerView

struct ItemKey{
    var id: Int;
    var title: String;
    var thumb: String;
    var description: String;
}

class  InitialCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
}

class InitialViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var btnPrevious: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pagerControl: UIPageControl!
    var dataArray : [ItemKey] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.isPagingEnabled = true
        dataArray.append(ItemKey(id: 0, title: "Watch on any device", thumb: "ic_device", description: "Pay once and stream sermons on your phone, tablets, laptop and TV."))
        dataArray.append(ItemKey(id: 0, title: "Get a discount", thumb: "ic-discount", description: "Belong to a church and pay less."))
        dataArray.append(ItemKey(id: 0, title: "How do I watch?", thumb: "ic-watch", description: "Subscribe on any platform and have access to all videos here on your app."))
        dataArray.append(ItemKey(id: 0, title: "Shop Christian Goods!", thumb: "ic-shop", description: "Without subscribing, buy christian goodies on this app."))
        pagerControl.numberOfPages = dataArray.count
        pagerControl.currentPage = 0
        pagerControl.isUserInteractionEnabled = false
        btnPrevious.isHidden = true
        pagerControl.pageIndicatorTintColor = UIColor.white
        let blueDotColor = UIColor(red: 18.0 / 255.0, green: 103.0 / 255.0, blue: 172.0 / 255.0, alpha: 1.0)
        pagerControl.currentPageIndicatorTintColor = blueDotColor
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! InitialCollectionViewCell
        let currentItem = dataArray[indexPath.row]
        cell.imgView.image = UIImage(named: currentItem.thumb)
        cell.lblTitle.text = currentItem.title
        cell.lblDescription.text = currentItem.description
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width , height: collectionView.frame.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()
        
        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size
        
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        guard let indexPath = collectionView.indexPathForItem(at: visiblePoint) else { return }
        pagerControl.currentPage = Int(indexPath.row)
        if pagerControl.currentPage == 0 {
            btnPrevious.isHidden = true
        }
        else{
            btnPrevious.isHidden = false
        }
        
        if pagerControl.currentPage == 3 {
            setBtnTitle(btn: btnNext, title: "Get started")
        }
        else{
            setBtnTitle(btn: btnNext, title: "Next")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    func setBtnTitle(btn: UIButton, title: String){
        let attributedTitle = NSAttributedString(string: title,
                                                         attributes: [NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
        btn.setAttributedTitle(attributedTitle, for: .normal)
    }
  
    @IBAction func btnNextAction(_ sender: Any) {
       if pagerControl.currentPage < dataArray.count - 1 {
           collectionView.scrollToNextItem()
       }
       else {
          navigateToLogin()
       }
    }
    
    @IBAction func btnPreviousAction(_ sender: Any) {
        if pagerControl.currentPage < dataArray.count - 1 {
            if pagerControl.currentPage != 0 {
                collectionView.scrollToPreviousItem()
            }
        }
    }
    
}
