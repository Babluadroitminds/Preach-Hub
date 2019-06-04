//
//  AllPastorsViewController.swift
//  Preach Hub
//
//  Created by Adroitminds on 20/05/19.
//  Copyright © 2019 AdroitMinds. All rights reserved.
//

import UIKit


struct listPastor {
    var name : String!
    var imageName : String!
}
class PastorListCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var imgView: UIImageView!
}

class ListViewController: UIViewController,UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var dataList: [DataKey] = []
    var listPastorArray = [listPastor]()
    var header: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblHeader.text = header
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PastorCell", for: indexPath) as! PastorListCollectionViewCell
        let currentItem = dataList[indexPath.row]
        cell.lblName.text = currentItem.title
        let imageUrl = currentItem.thumb
        let urlString = imageUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        cell.imgView.sd_setShowActivityIndicatorView(true)
        cell.imgView.sd_setIndicatorStyle(.gray)
        cell.imgView.sd_setImage(with: URL.init(string: urlString!) , placeholderImage: UIImage.init(named:""))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let noOfCellsInRow = 2
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(header == "STORE"){
            navigateToProductPage(index: indexPath.row)
        }
    }
    
    func navigateToProductPage(index: Int){
        let ProductVC = ProductViewController.storyboardInstance()
        ProductVC!.categoryId = dataList[index].id
        ProductVC!.categoryTitle = dataList[index].title
        self.navigationController?.pushViewController(ProductVC!, animated: true)
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    static func storyboardInstance() -> ListViewController? {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "ListViewController") as? ListViewController
    }
}
