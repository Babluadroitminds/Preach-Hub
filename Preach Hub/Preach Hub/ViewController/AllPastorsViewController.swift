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

class AllPastorsViewController: UIViewController,UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var listPastorArray = [listPastor]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let p1 = listPastor(name: "Radadsa", imageName: "minister_mukhubatwo.png")
        let p2 = listPastor(name: "Tsfs", imageName: "minister_muligwe.png")
        let p3 = listPastor(name: "Tinkszd", imageName: "minister_paul.png")
        let p4 = listPastor(name: "Sdsfds", imageName: "minister_masekona.png")
        let p5 = listPastor(name: "Qwdmded", imageName: "minister_mauna.png")
        let p6 = listPastor(name: "Pfnjsds", imageName: "minister_muligwe.png")
        let p7 = listPastor(name: "Joinsad", imageName: "minister_paul.png")
        listPastorArray.append(p1)
        listPastorArray.append(p2)
        listPastorArray.append(p3)
        listPastorArray.append(p4)
        listPastorArray.append(p5)
        listPastorArray.append(p6)
        listPastorArray.append(p7)
        // Do any additional setup after loading the view.
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listPastorArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PastorCell", for: indexPath) as! PastorListCollectionViewCell
        cell.imgView.image = UIImage(named: listPastorArray[indexPath.row].imageName)
        cell.lblName.text = listPastorArray[indexPath.row].name
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
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
