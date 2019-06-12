//
//  HomeDetailsViewController.swift
//  Preach Hub
//
//  Created by Divya on 06/06/19.
//  Copyright © 2019 AdroitMinds. All rights reserved.
//

import UIKit
import SwiftyJSON
import DropDown
import CoreData
import Toast_Swift
import AVKit
import AVFoundation

struct SermonsTestimony
{
    var imageThumb: String
    var title: String
    var duration: String
    var id : String
    var video : String
}

struct Product{
    var id : String
    var imageThumb: String
    var title: String
    var price: String
}

class noDataCell: UITableViewCell
{
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
}
class paymentCell: UITableViewCell
{
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
}
class ProductCell: UITableViewCell
{
    @IBOutlet weak var imgVwProduct: UIImageView!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnMore: UIButton!
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
}
class sermonsCell: UITableViewCell
{
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var moreView: UIView!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var availableLbl: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var sermonImage: UIImageView!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
}
class sectionHeaderCell: UITableViewCell
{
    @IBOutlet var segmentControl: ScrollableSegmentedControl!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        if self.segmentControl.numberOfSegments == 0
        {
            self.segmentControl.segmentStyle = .textOnly
            
            self.segmentControl.underlineSelected = true
            
            self.segmentControl.segmentContentColor = UIColor(red: 57/255.0, green: 146/255.0, blue: 223/255.0, alpha: 1.0)
            self.segmentControl.selectedSegmentContentColor = UIColor(red: 57/255.0, green: 146/255.0, blue: 223/255.0, alpha: 1.0)
            self.segmentControl.tintColor = UIColor(red: 57/255.0, green: 146/255.0, blue: 223/255.0, alpha: 1.0)
            self.segmentControl.backgroundColor = UIColor(red: 45/255.0, green: 45/255.0, blue: 45/255.0, alpha: 1.0)
            
            self.segmentControl.fixedSegmentWidth = false
        }
    }
}
class segmentData: UITableViewCell
{
    @IBOutlet weak var aboutLbl: UILabel!
    
    @IBOutlet weak var secondView: UIView!
    
}
class HomeDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet var tableView: UITableView!
    
    var detailsDict = [String : JSON]()
    var semonsArr = [SermonsTestimony]()
    var testimonyArr = [SermonsTestimony]()
    var productsArr = [ProductKey]()
        
    var height = 0
    var segmentIndex = 0
    
    var moreIndex = -1
    var id: String?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        height = Int(UIScreen.main.bounds.size.height - 110)
        
        if UIDevice().userInterfaceIdiom == .phone
        {
            let screenHeight = UIScreen.main.nativeBounds.height
            
            if screenHeight == 2436 || screenHeight == 2688 || screenHeight == 1792
            {
                height = Int(UIScreen.main.bounds.size.height - 135)
            }
            else //if height == 1136 || height == 1334 || height == 1920 || height == 2208
            {
                height = Int(UIScreen.main.bounds.size.height - 80)
            }
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedSectionHeaderHeight = 40.0
        self.automaticallyAdjustsScrollViewInsets = false
        // Set a header for the table view
        //        let header = UIImageView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 350))
        //        header.backgroundColor = .red
        //        header.image = #imageLiteral(resourceName: "pizza")
        
        
        let header = DetailsHeaderView(frame: CGRect(x: 0, y: 0, width: 50, height: 300))
        
        header.nameLbl.text = detailsDict["name"]!.string!
        
        if detailsDict["img_thumb"]!.string! != ""
        {
            let url = URL(string: detailsDict["img_thumb"]!.string!)
            if let dataImage = try? Data(contentsOf: url!)
            {
                header.bgImage.image = UIImage(data: dataImage)
                header.middleImage.image = UIImage(data: dataImage)
            }
        }
        tableView.tableHeaderView = header
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.topBackTapped), name: NSNotification.Name(rawValue: "topBackTapped"), object: nil)
        id = detailsDict["id"]?.string
        if detailsDict["pastorsermons"] != nil
        {
            if detailsDict["pastorsermons"]?.array?.count != 0
            {
                for item in detailsDict["pastorsermons"]!.array!
                {
                    self.semonsArr.append(SermonsTestimony(imageThumb: item["img_thumb"] != JSON.null ? item["img_thumb"].string! : "", title: item["name"] != JSON.null ? item["name"].string! : "", duration: item["duration"] != JSON.null ? item["duration"].string! : "", id: item["id"] != JSON.null ? item["id"].string! : "", video: item["video"] != JSON.null ? item["video"].string! : ""))
                }
            }
        }
        
        if detailsDict["testimonies"] != nil
        {
            if detailsDict["testimonies"]?.array?.count != 0
            {
                for item in detailsDict["testimonies"]!.array!
                {
                    self.testimonyArr.append(SermonsTestimony(imageThumb: item["img_thumb"] != JSON.null ? item["img_thumb"].string! : "", title: item["name"] != JSON.null ? item["name"].string! : "", duration: item["duration"] != JSON.null ? item["duration"].string! : "", id: item["id"] != JSON.null ? item["id"].string! : "", video: item["video"] != JSON.null ? item["video"].string! : ""))
                }
            }
        }
        
        if detailsDict["products"] != nil
        {
            if detailsDict["products"]?.array?.count != 0
            {
                for item in detailsDict["products"]!.array!
                {
                    self.productsArr.append(ProductKey(id: item["id"] != JSON.null ? item["id"].string! : "",name:  item["name"] != JSON.null ? item["name"].string! : "",price: item["price"] != JSON.null ? item["price"].string! : "",categoryid: item["categoryid"] != JSON.null ?item["categoryid"].string! : "",thumb: item["img_thumb"] != JSON.null ? item["img_thumb"].string! : "",productcode: item["productcode"] != JSON.null ? item["productcode"].string! : "", productsize: item["productsize"] != JSON.null ? item["productsize"].string! : "", quantity: item["quantity"] != JSON.null ? item["quantity"].string! : "", colourid: item["colourid"] != JSON.null ? item["colourid"].string! : "",isActive: item["is_active"] != JSON.null ? item["is_active"].bool! : true))
                }
            }
        }
    }
    override func viewDidAppear(_ animated: Bool)
    {
        self.tableView.reloadSections([1], with: .automatic)
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @objc func topBackTapped(notification: NSNotification)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        if section == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "sectionHeader") as? sectionHeaderCell
            
            cell?.segmentControl.addTarget(self, action: #selector(self.segmentSelected(sender:)), for: .valueChanged)
            
            cell?.segmentControl.insertSegment(withTitle: "ABOUT", image: nil, at: 0)
            cell?.segmentControl.insertSegment(withTitle: "PRODUCTS", image: nil, at: 1)
            cell?.segmentControl.insertSegment(withTitle: "SERMONS", image: nil, at: 2)
            cell?.segmentControl.insertSegment(withTitle: "TITHE", image: nil, at: 3)
            cell?.segmentControl.insertSegment(withTitle: "TESTIMONY", image: nil, at: 4)
            
            cell?.segmentControl.selectedSegmentIndex = 0
            
            return cell
        }
        else
        {
            let view = UIView()
            return view
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if section == 0
        {
            return 60
        }
        else
        {
            return CGFloat.leastNormalMagnitude
        }
    }
    @objc func segmentSelected(sender: ScrollableSegmentedControl)
    {
        self.segmentIndex = sender.selectedSegmentIndex
        
        self.tableView.reloadSections([1], with: .automatic)
    }
    //MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        print("self.segmentIndexself.segmentIndex : ", self.segmentIndex)
        
        if section == 0
        {
            return 0
        }
        else
        {
            if self.segmentIndex == 1
            {
                return self.productsArr.count + 1
            }
            else if self.segmentIndex == 2
            {
                return self.semonsArr.count + 1
            }
            else if self.segmentIndex == 4
            {
                return self.testimonyArr.count + 1
            }
            return 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if self.segmentIndex == 1
        {
            if self.productsArr.count == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "noDataCell") as? noDataCell
                return cell!
            }
            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "productCell") as? ProductCell
                    if self.productsArr.count >= 3{
                        if indexPath.row < 3 {
                            cell?.lblTitle.isHidden = false
                            cell?.lblPrice.isHidden = false
                            cell?.imgVwProduct.isHidden = false
                            cell?.btnMore.isHidden = true
                            cell?.lblTitle.text = self.productsArr[indexPath.row].name
                            cell?.lblPrice.text = "$" + self.productsArr[indexPath.row].price
                            let imageUrl = self.productsArr[indexPath.row].thumb
                            let urlString = imageUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                            cell!.imgVwProduct.sd_setShowActivityIndicatorView(true)
                            cell!.imgVwProduct.sd_setIndicatorStyle(.gray)
                            cell!.imgVwProduct.sd_setImage(with: URL.init(string: urlString!) , placeholderImage: UIImage.init(named:"ic-placeholder.png"))
                            if indexPath.row == self.productsArr.count{
                                cell?.imgVwProduct.isHidden = true
                                cell?.btnMore.isHidden = false
                                cell?.lblTitle.isHidden = true
                                cell?.lblPrice.isHidden = true
                                cell?.btnMore.addTarget(self, action: #selector(btnMoreProductClicked), for: .touchUpInside)
                            }
                        }
                        else {
                            cell?.lblTitle.isHidden = true
                            cell?.lblPrice.isHidden = true
                            cell?.imgVwProduct.isHidden = true
                            if indexPath.row == 3{
                                cell?.btnMore.isHidden = false
                                cell?.btnMore.addTarget(self, action: #selector(btnMoreProductClicked), for: .touchUpInside)
                            }
                            else{
                                cell?.btnMore.isHidden = true
                            }
                        }
                
                    }
                        
                    else{
                        if indexPath.row == self.productsArr.count{
                            cell?.imgVwProduct.isHidden = true
                            cell?.btnMore.isHidden = false
                            cell?.lblTitle.isHidden = true
                            cell?.lblPrice.isHidden = true
                            cell?.btnMore.addTarget(self, action: #selector(btnMoreProductClicked), for: .touchUpInside)
                        }
                        else{
                            cell?.lblTitle.isHidden = false
                            cell?.lblPrice.isHidden = false
                            cell?.imgVwProduct.isHidden = false
                            cell?.btnMore.isHidden = true
                            cell?.lblTitle.text = self.productsArr[indexPath.row].name
                            cell?.lblPrice.text = "$" + self.productsArr[indexPath.row].price
                            let imageUrl = self.productsArr[indexPath.row].thumb
                            let urlString = imageUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                            cell!.imgVwProduct.sd_setShowActivityIndicatorView(true)
                            cell!.imgVwProduct.sd_setIndicatorStyle(.gray)
                            cell!.imgVwProduct.sd_setImage(with: URL.init(string: urlString!) , placeholderImage: UIImage.init(named:"ic-placeholder.png"))
                        }
                   
                }
                return cell!
            }
        }
        else if self.segmentIndex == 2
        {
            if self.semonsArr.count == 0
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "noDataCell") as? noDataCell
                return cell!
            }
            else
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "sermonsCell") as? sermonsCell
                
                if indexPath.row == self.semonsArr.count
                {
                    cell!.sermonImage.isHidden = true
                    cell!.name.isHidden = true
                    cell!.timeLbl.isHidden = true
                    cell!.availableLbl.isHidden = true
                    cell!.moreView.isHidden = true
                }
                else
                {
                    cell!.sermonImage.isHidden = false
                    cell!.name.isHidden = false
                    cell!.timeLbl.isHidden = false
                    cell!.availableLbl.isHidden = false
                    cell!.moreView.isHidden = false
                    
                    let imageUrl = self.semonsArr[indexPath.row].imageThumb
                    let urlString = imageUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                    cell!.sermonImage.sd_setShowActivityIndicatorView(true)
                    cell!.sermonImage.sd_setIndicatorStyle(.gray)
                    cell!.sermonImage.sd_setImage(with: URL.init(string: urlString!) , placeholderImage: UIImage.init(named:"ic-placeholder.png"))
                    
                    cell!.name.text = self.semonsArr[indexPath.row].title
                    cell!.timeLbl.text = self.semonsArr[indexPath.row].duration
                    
                    cell!.moreBtn.tag = indexPath.row
                }
                return cell!
            }
        }
        else if self.segmentIndex == 3
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "paymentCell") as? paymentCell
            return cell!
        }
        else if self.segmentIndex == 4
        {
            if self.testimonyArr.count == 0
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "noDataCell") as? noDataCell
                return cell!
            }
            else
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "sermonsCell") as? sermonsCell
                
                if indexPath.row == self.testimonyArr.count
                {
                    cell!.sermonImage.isHidden = true
                    cell!.name.isHidden = true
                    cell!.timeLbl.isHidden = true
                    cell!.availableLbl.isHidden = true
                    cell!.moreView.isHidden = true
                }
                else
                {
                    let imageUrl = self.testimonyArr[indexPath.row].imageThumb
                    let urlString = imageUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                    cell!.sermonImage.sd_setShowActivityIndicatorView(true)
                    cell!.sermonImage.sd_setIndicatorStyle(.gray)
                    cell!.sermonImage.sd_setImage(with: URL.init(string: urlString!) , placeholderImage: UIImage.init(named:"ic-placeholder.png"))
                    
                    cell!.name.text = self.testimonyArr[indexPath.row].title
                    cell!.timeLbl.text = self.testimonyArr[indexPath.row].duration
                    
                    cell!.moreBtn.tag = indexPath.row
                }
                return cell!
            }
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellID") as? segmentData
            
            cell?.aboutLbl.text = detailsDict["description"]!.string!
            cell?.aboutLbl.isHidden = false
            
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.segmentIndex == 2 {
            if self.semonsArr.count != 0 {
                let currentItem = semonsArr[indexPath.row]
                let videoURL = URL(string: currentItem.video)
                let player = AVPlayer(url: videoURL!)
                let vc = AVPlayerViewController()
                vc.player = player
                
                present(vc, animated: true) {
                    vc.player?.play()
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if self.segmentIndex == 1
        {
            if self.productsArr.count == 0
            {
                return CGFloat(self.height)
            }
            else if indexPath.row == self.productsArr.count
            {
                let rowHeight = 70 * self.productsArr.count
                
                if rowHeight < self.height
                {
                    let minus = self.height - rowHeight
                    return CGFloat(minus)
                }
                else
                {
                    return 0
                }
            }
            return 70
        }
        else if self.segmentIndex == 2
        {
            if self.semonsArr.count == 0
            {
                return CGFloat(self.height)
            }
            else if indexPath.row == self.semonsArr.count
            {
                let rowHeight = 70 * self.semonsArr.count
                
                if rowHeight < self.height
                {
                    let minus = self.height - rowHeight
                    return CGFloat(minus)
                }
                else
                {
                    return 0
                }
            }
            return 70
        }
        else if self.segmentIndex == 4
        {
            if self.testimonyArr.count == 0
            {
                return CGFloat(self.height)
            }
            else if indexPath.row == self.testimonyArr.count
            {
                let rowHeight = 70 * self.testimonyArr.count
                
                if rowHeight < self.height
                {
                    let minus = self.height - rowHeight
                    return CGFloat(minus)
                }
                else
                {
                    return 0
                }
            }
            return 70
        }
        return CGFloat(self.height)
    }
    
    @objc func btnMoreProductClicked(sender: UIButton) {
        let ProductVC = ProductViewController.storyboardInstance()
        ProductVC!.parentId = id
        ProductVC!.categoryTitle = "All"
        ProductVC!.productList = productsArr
        ProductVC!.isPastor = true
        self.navigationController?.pushViewController(ProductVC!, animated: true)
    }
    
    @objc func donePickerClicked()
    {
        self.view.endEditing(true)
    }
    @IBAction func moreTapped(_ sender: UIButton)
    {
        self.moreIndex = sender.tag
        
        let dropDown = DropDown()
        
        dropDown.anchorView = sender
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        
        dropDown.dataSource = ["Favourite", "Share"]
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in

            if index == 1
            {
                var textToShare = [String]()
                
                if self.segmentIndex == 2
                {
                    textToShare = [self.semonsArr[sender.tag].title]
                }
                else
                {
                    textToShare = [self.testimonyArr[sender.tag].title]
                }
                let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view
                
                activityViewController.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
                
                self.present(activityViewController, animated: true, completion: nil)
            }
            else
            {
                self.alreadyExistCheck(index: sender.tag)
            }
        }
        
        dropDown.width = 150
        dropDown.dismissMode = .onTap
        
        dropDown.show()
    }
    func alreadyExistCheck(index : Int)
    {
        var id = ""
        var type = ""

        if self.segmentIndex == 2
        {
            id = self.semonsArr[index].id
            type = "sermons"
        }
        else
        {
            id = self.semonsArr[index].id
            type = "testimony"
        }
        let userId = UserDefaults.standard.value(forKey: "memberId") as? String

        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate?.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favourite")
        
        let idKeyPredicate = NSPredicate(format: "favId = %@", id)
        let typeKeyPredicate = NSPredicate(format: "type = %@", type)
        
        let userIdKeyPredicate = NSPredicate(format: "userId == %@", userId!)
        
        let andPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [idKeyPredicate, typeKeyPredicate, userIdKeyPredicate])
                
        fetchRequest.predicate = andPredicate
        
        do
        {
            let fetchResults = try managedContext!.fetch(fetchRequest) as? [Favourite]
            
            if fetchResults?.count != 0
            {
                let style = ToastStyle()
                
                self.view.makeToast("Already added in Favourites", duration: 3.0, position: .bottom, title: nil, image: nil, style: style , completion: nil)
            }
            else
            {
                self.saveFavourite(index : index)
            }
        }
        catch
        {
            print("coreDataFetchFail")
        }
    }
    func saveFavourite(index : Int)
    {
        var imageStr = ""
        var name = ""
        var id = ""
        var type = ""
        
        if self.segmentIndex == 2
        {
            name = self.semonsArr[index].title
            imageStr = self.semonsArr[index].imageThumb
            id = self.semonsArr[index].id
            type = "sermons"
        }
        else
        {
            name = self.testimonyArr[index].title
            imageStr = self.semonsArr[index].imageThumb
            id = self.semonsArr[index].id
            type = "testimony"
        }
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate?.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Favourite", in: managedContext!)!
        
        let user = NSManagedObject(entity: entity, insertInto: managedContext!)
        
        let userId = UserDefaults.standard.value(forKey: "memberId") as? String
        
        user.setValue(userId, forKey: "userId")
        
        user.setValue(id, forKey: "favId")
        user.setValue(imageStr, forKey: "imageStr")
        user.setValue(name, forKey: "name")
        user.setValue(userId, forKey: "userId")
        user.setValue(type, forKey: "type")
        
        do
        {
            try managedContext?.save()
        }
        catch let error as NSError
        {
            print("errorCoreData : ", error.userInfo)
        }
        
        let style = ToastStyle()
        
        self.view.makeToast("Favourites added", duration: 3.0, position: .bottom, title: nil, image: nil, style: style , completion: nil)
    }
}
