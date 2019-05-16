//
//  InitialViewController.swift
//  Preach Hub
//
//  Created by Sajeev S L on 16/05/19.
//  Copyright © 2019 AdroitMinds. All rights reserved.
//

import UIKit

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

class InitialViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pagerControl: UIPageControl!
    var dataArray : [ItemKey] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataArray.append(ItemKey(id: 0, title: "Watch on any device", thumb: "ic_device", description: "Pay once and stream sermons on your phone, tablets, laptop and TV."))
        dataArray.append(ItemKey(id: 0, title: "Get a discount", thumb: "ic-discount", description: "Belong to a church and pay less."))
        dataArray.append(ItemKey(id: 0, title: "How do I watch?", thumb: "ic-watch", description: "Subscribe on any platform and have access to all videos here on your app."))
        dataArray.append(ItemKey(id: 0, title: "Shop Christian Goods!", thumb: "ic-shop", description: "Without subscribing, buy christian goodies on this app."))
        pagerControl.numberOfPages = dataArray.count
        pagerControl.currentPage = 0
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()
        
        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size
        
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        guard let indexPath = collectionView.indexPathForItem(at: visiblePoint) else { return }
        pagerControl.currentPage = Int(indexPath.row)
    }
  
}
