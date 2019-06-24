//
//  ChurchDetailsViewController.swift
//  Preach Hub
//
//  Created by Sajeev S L on 12/06/19.
//  Copyright © 2019 AdroitMinds. All rights reserved.
//

import UIKit
import SwiftyJSON
import DropDown
import CoreData
import Toast_Swift
import AVKit
import AVFoundation
import CoreLocation
import MapKit
//struct SermonsTestimony
//{
//    var imageThumb: String
//    var title: String
//    var duration: String
//    var id : String
//    var video : String
//}
//
//struct Product{
//    var id : String
//    var imageThumb: String
//    var title: String
//    var price: String
//}
//
//class noDataCell: UITableViewCell
//{
//    override func awakeFromNib()
//    {
//        super.awakeFromNib()
//    }
//}
//class paymentCell: UITableViewCell
//{
//    override func awakeFromNib()
//    {
//        super.awakeFromNib()
//    }
//}

//class sermonsCell: UITableViewCell
//{
//    @IBOutlet weak var moreBtn: UIButton!
//    @IBOutlet weak var moreView: UIView!
//    @IBOutlet weak var timeLbl: UILabel!
//    @IBOutlet weak var availableLbl: UILabel!
//    @IBOutlet weak var name: UILabel!
//    @IBOutlet weak var sermonImage: UIImageView!
//
//    override func awakeFromNib()
//    {
//        super.awakeFromNib()
//    }
//}

struct EventKey {
    var id: String
    var name: String
    var venue: String
    var thumb: String
    var endDate: String
}

struct BranchKey {
    var id: String
    var name: String
    var description: String
    var status: String
    var address: String
    var cellphone: String
    var leader: String
}

class BranchCell: UITableViewCell{
    @IBOutlet weak var btnDirection: UIButton!
    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLeader: UILabel!
    @IBOutlet weak var imgVwBranch: UIImageView!
    @IBOutlet weak var vwContainer: UIView!
    override func awakeFromNib(){
        super.awakeFromNib()
    }
}

class EventCell: UITableViewCell{
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblMonth: UILabel!
    @IBOutlet weak var lblVenue: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var imgVwEvent: UIImageView!
    override func awakeFromNib(){
        super.awakeFromNib()
    }
}

class MembershipFormCell: UITableViewCell{
    
    @IBOutlet weak var vwContactNumber: UIView!
    @IBOutlet weak var vwLastName: UIView!
    @IBOutlet weak var btnApply: UIButton!
    @IBOutlet weak var vwEmail: UIView!
    @IBOutlet weak var vwOccupation: UIView!
    @IBOutlet weak var vwFirstName: UIView!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtContactNumber: UITextField!
    @IBOutlet weak var txtOccupation: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtFirstName: UITextField!
    
    override func awakeFromNib(){
        super.awakeFromNib()
    }
}

class sectionsHeaderCell: UITableViewCell
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
//class segmentData: UITableViewCell
//{
//    @IBOutlet weak var aboutLbl: UILabel!
//
//    @IBOutlet weak var secondView: UIView!
//
//}
class ChurchDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet var tableView: UITableView!
    
    var detailsDict = [String : JSON]()
    var semonsArr = [SermonsTestimony]()
    var testimonyArr = [SermonsTestimony]()
    var productsArr = [ProductKey]()
    var branchArr = [BranchKey]()
    var eventArr = [EventKey]()
    var height = 0
    var segmentIndex = 0
    
    var moreIndex = -1
    var id: String?
    var locManager = CLLocationManager()
    var player: AVPlayer?
    
    var sectionHeaderCellCount: Int = 7

    var profileDetails : [String : String]!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if UserDefaults.standard.value(forKey: "ProfileDetails") as? Data != nil
        {
            let data = UserDefaults.standard.value(forKey: "ProfileDetails") as? Data
            self.profileDetails = (NSKeyedUnarchiver.unarchiveObject(with: data!)! as? [String : String])!
        }
        
        let headerNib = UINib.init(nibName: "sectionHeader", bundle: Bundle.main)
        self.tableView.register(headerNib, forHeaderFooterViewReuseIdentifier: "sectionHeader")
        
        locManager.requestWhenInUseAuthorization()
        
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
        if detailsDict["branches"] != nil{
            if detailsDict["branches"]?.array?.count != 0{
                for item in detailsDict["branches"]!.array!{
                    self.branchArr.append(BranchKey(id: item["id"] != JSON.null ? item["id"].string! : "", name: item["name"] != JSON.null ? item["name"].string! : "", description: item["description"] != JSON.null ? item["description"].string! : "", status: item["status"] != JSON.null ? item["status"].string! : "", address: item["address"] != JSON.null ? item["address"].string! : "", cellphone: item["cellphone"] != JSON.null ? item["cellphone"].string! : "", leader: item["leadername"] != JSON.null ? item["leadername"].string! : ""))
                }
            }
        }
        
        if detailsDict["events"] != nil{
            if detailsDict["events"]?.array?.count != 0{
                for item in detailsDict["events"]!.array!{
                    self.eventArr.append(EventKey(id: item["id"] != JSON.null ? item["id"].string! : "", name: item["name"] != JSON.null ? item["name"].string! : "", venue: item["venue"] != JSON.null ? item["venue"].string! : "", thumb: item["img_thumb"] != JSON.null ? item["img_thumb"].string! : "", endDate: item["enddate"] != JSON.null ? item["enddate"].string! : ""))
                }
            }
        }
//
//        if detailsDict["testimonies"] != nil
//        {
//            if detailsDict["testimonies"]?.array?.count != 0
//            {
//                for item in detailsDict["testimonies"]!.array!
//                {
//                    self.testimonyArr.append(SermonsTestimony(imageThumb: item["img_thumb"] != JSON.null ? item["img_thumb"].string! : "", title: item["name"] != JSON.null ? item["name"].string! : "", duration: item["duration"] != JSON.null ? item["duration"].string! : "", id: item["id"] != JSON.null ? item["id"].string! : "", video: item["video"] != JSON.null ? item["video"].string! : ""))
//                }
//            }
//        }
//
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
        
        self.setGestureLayout()
    }
    override func viewDidAppear(_ animated: Bool)
    {
        self.tableView.reloadSections([1], with: .automatic)
    }

    func textFieldDidEndEditing(_ textField: UITextField)
    {
        let indexPath = IndexPath(row: 0, section: 1)
        let cell = self.tableView.cellForRow(at: indexPath) as? MembershipFormCell
        
        if cell?.txtEmail == textField
        {
            self.profileDetails["Email"] = textField.text
        }
        else if cell?.txtContactNumber == textField
        {
            self.profileDetails["ContactNumber"] = textField.text
        }
        else if cell?.txtOccupation == textField
        {
            self.profileDetails["Occupation"] = textField.text
        }
        else if cell?.txtLastName == textField
        {
            self.profileDetails["LastName"] = textField.text
        }
        else if cell?.txtFirstName == textField
        {
            self.profileDetails["FirstName"] = textField.text
        }
    }
    func setGestureLayout()
    {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeRight(gestureRecognizer:)))
        swipeRight.delegate = self
        swipeRight.numberOfTouchesRequired = 1
        swipeRight.delaysTouchesBegan = true
        swipeRight.direction = .right
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeLeft(gestureRecognizer:)))
        swipeLeft.delegate = self
        swipeLeft.numberOfTouchesRequired = 1
        swipeLeft.delaysTouchesBegan = true
        swipeLeft.direction = .left
        
        tableView?.addGestureRecognizer(swipeRight)
        tableView?.addGestureRecognizer(swipeLeft)
    }
    @objc func didSwipeRight(gestureRecognizer : UISwipeGestureRecognizer)
    {
        if self.segmentIndex != 0
        {
            self.segmentIndex = self.segmentIndex  - 1
            
            //            self.tableView.reloadData()
            self.tableView.reloadSections([1], with: .automatic)
            
            let customCell = self.tableView.headerView(forSection: 0) as! sectionHeaderView
            self.updateHeaderView(customCell: customCell, section: 0)
        }
    }
    
    @objc func didSwipeLeft(gestureRecognizer : UISwipeGestureRecognizer)
    {
        if self.segmentIndex + 1 != self.sectionHeaderCellCount
        {
            self.segmentIndex = self.segmentIndex + 1
            
            //            self.tableView.reloadData()
            self.tableView.reloadSections([1], with: .automatic)
            
            let customCell = self.tableView.headerView(forSection: 0) as! sectionHeaderView
            self.updateHeaderView(customCell: customCell, section: 0)
        }
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @objc func topBackTapped(notification: NSNotification)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    func updateHeaderView(customCell: sectionHeaderView, section: Int)
    {
        customCell.segmentControl.selectedSegmentIndex = self.segmentIndex
    }
    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        if section == 0
        {
            let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "sectionHeader") as? sectionHeaderView
            
            cell?.segmentControl.addTarget(self, action: #selector(self.segmentSelected(sender:)), for: .valueChanged)

            cell?.segmentControl.insertSegment(withTitle: "STATEMENT OF FAITH", image: nil, at: 0)
            cell?.segmentControl.insertSegment(withTitle: "PRODUCTS", image: nil, at: 1)
            cell?.segmentControl.insertSegment(withTitle: "MEMBERSHIP FORM", image: nil, at: 2)
            cell?.segmentControl.insertSegment(withTitle: "EVENTS", image: nil, at: 3)
            cell?.segmentControl.insertSegment(withTitle: "BIBLE COLLEGE", image: nil, at: 4)
            cell?.segmentControl.insertSegment(withTitle: "HOME CELLS/BRANCHES", image: nil, at: 5)
            cell?.segmentControl.insertSegment(withTitle: "OFFERING", image: nil, at: 6)

            
            cell?.segmentControl.selectedSegmentIndex = self.segmentIndex
            
            
            self.updateHeaderView(customCell: cell!, section: 0)
            
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
            if self.segmentIndex == 1{
                return self.productsArr.count + 1
            }
            else if self.segmentIndex == 2{
                return 2
            }
            else if self.segmentIndex == 3 {
                return self.eventArr.count + 1
            }
            else if self.segmentIndex == 4
            {
                return self.testimonyArr.count + 1
            }
            else if self.segmentIndex == 5 {
                return self.branchArr.count + 1
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "membershipFormCell") as? MembershipFormCell
            
            if indexPath.row == 1
            {
                cell?.lblHeading.isHidden = true
                cell?.vwFirstName.isHidden = true
                cell?.vwLastName.isHidden = true
                cell?.vwContactNumber.isHidden = true
                cell?.vwEmail.isHidden = true
                cell?.vwOccupation.isHidden = true
                cell?.btnApply.isHidden = true
            }
            else
            {
                if self.profileDetails != nil
                {
                    cell?.txtEmail.text = self.profileDetails["Email"]
                    cell?.txtContactNumber.text = self.profileDetails["ContactNumber"]
                    cell?.txtOccupation.text = self.profileDetails["Occupation"]
                    cell?.txtLastName.text = self.profileDetails["LastName"]
                    cell?.txtFirstName.text = self.profileDetails["FirstName"]
                }
                
                cell?.txtEmail.delegate = self
                cell?.txtContactNumber.delegate = self
                cell?.txtOccupation.delegate = self
                cell?.txtLastName.delegate = self
                cell?.txtFirstName.delegate = self
                
                cell?.lblHeading.isHidden = false
                cell?.vwFirstName.isHidden = false
                cell?.vwLastName.isHidden = false
                cell?.vwContactNumber.isHidden = false
                cell?.vwEmail.isHidden = false
                cell?.vwOccupation.isHidden = false
                cell?.btnApply.isHidden = false
                cell?.btnApply.addTarget(self, action: #selector(btnApplyMembership(sender:)), for: .touchUpInside)
                cell?.btnApply.tag = indexPath.row
            }
            return cell!
        }
        else if self.segmentIndex == 3 {
            if self.eventArr.count == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "noDataCell") as? noDataCell
                return cell!
            }
            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell") as? EventCell
                
                if indexPath.row == self.eventArr.count{
                    cell!.imgVwEvent.isHidden = true
                    cell!.lblName.isHidden = true
                    cell!.lblMonth.isHidden = true
                    cell!.lblDate.isHidden = true
                    cell!.lblVenue.isHidden = true
                    cell!.btnShare.isHidden = true
                }
                else{
                    cell!.imgVwEvent.isHidden = false
                    cell!.lblName.isHidden = false
                    cell!.lblMonth.isHidden = false
                    cell!.lblDate.isHidden = false
                    cell!.lblVenue.isHidden = false
                    cell!.btnShare.isHidden = false
                    
                    let imageUrl = self.eventArr[indexPath.row].thumb
                    let urlString = imageUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                    cell!.imgVwEvent.sd_setShowActivityIndicatorView(true)
                    cell!.imgVwEvent.sd_setIndicatorStyle(.gray)
                    cell!.imgVwEvent.sd_setImage(with: URL.init(string: urlString!) , placeholderImage: UIImage.init(named:"ic-placeholder.png"))
                    
                    cell!.lblName.text = self.eventArr[indexPath.row].name
                    cell!.lblVenue.text = self.eventArr[indexPath.row].venue
                    
                    let dateString = self.eventArr[indexPath.row].endDate
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"
                    let dateFromString = formatter.date(from: dateString)
                    
                    let dateFormatter2 = DateFormatter()
                    dateFormatter2.dateFormat = "MMM"
                    let month = dateFormatter2.string(from: dateFromString!)
                    dateFormatter2.dateFormat = "dd"
                    let day = dateFormatter2.string(from: dateFromString!)
                  
                    cell?.lblMonth.text = month
                    cell?.lblDate.text = day
                    cell!.btnShare.tag = indexPath.row
                    cell?.btnShare.addTarget(self, action: #selector(btnShareEventClicked(sender:)), for: .touchUpInside)
                }
                return cell!
            }
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
                    cell!.sermonImage.isHidden = false
                    cell!.name.isHidden = false
                    cell!.timeLbl.isHidden = false
                    cell!.availableLbl.isHidden = false
                    cell!.moreView.isHidden = false
                    
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
        else if self.segmentIndex == 5 {
            if self.branchArr.count == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "noDataCell") as? noDataCell
                return cell!
            }
            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "branchCell") as? BranchCell
                
                if indexPath.row == self.branchArr.count{
                    cell!.vwContainer.isHidden = true
                }
                else{
                    cell!.vwContainer.isHidden = false
                    cell!.lblName.text = self.branchArr[indexPath.row].name
                    cell!.lblLeader.text = self.branchArr[indexPath.row].leader
                    cell!.lblAddress.text = self.branchArr[indexPath.row].address
                    cell!.btnCall.tag = indexPath.row
                    cell!.btnDirection.tag = indexPath.row
                    let imageUrl = detailsDict["img_thumb"] != JSON.null ? detailsDict["img_thumb"]?.string! : ""
                    let urlString = imageUrl!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                    cell!.imgVwBranch.sd_setShowActivityIndicatorView(true)
                    cell!.imgVwBranch.sd_setIndicatorStyle(.gray)
                    cell!.imgVwBranch.sd_setImage(with: URL.init(string: urlString!) , placeholderImage: UIImage.init(named:"ic-placeholder.png"))
                    cell?.btnCall.addTarget(self, action: #selector(btnCallClicked), for: .touchUpInside)
                    cell?.btnDirection.addTarget(self, action: #selector(btnDirectionClicked), for: .touchUpInside)
                }
                return cell!
            }
        }
        else if self.segmentIndex == 6 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "paymentCell") as? paymentCell
            return cell!
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
                 player = AVPlayer(url: videoURL!)
                let vc = AVPlayerViewController()
                vc.player = player
                
                present(vc, animated: true) {
                    try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
                    vc.player?.play()
                }
//                NotificationCenter.default.addObserver(self, selector: #selector(ChurchDetailsViewController.itemDidPausePlaying(_:)), name: NSNotification.Name.AVPlayerItemPlaybackStalled, object: player)
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
        else if self.segmentIndex == 2{
            if indexPath.row == 1 {
                let minus = self.height - 540
                return CGFloat(minus)
            }
            return 540
        }
        else if self.segmentIndex == 3 {
            if self.eventArr.count == 0 {
                return CGFloat(self.height)
            }
            else if indexPath.row == self.eventArr.count {
                let rowHeight = 285 * self.eventArr.count
                
                if rowHeight < self.height {
                    let minus = self.height - rowHeight
                    return CGFloat(minus)
                }
                else{
                    return 0
                }
            }
            return 285
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
        else if self.segmentIndex == 5 {
            if self.branchArr.count == 0{
                return CGFloat(self.height)
            }
            else if indexPath.row == self.branchArr.count{
                let rowHeight = 265 * self.branchArr.count
                
                if rowHeight < self.height{
                    let minus = self.height - rowHeight
                    return CGFloat(minus)
                }
                else
                {
                    return 0
                }
            }
            return 265
        }
        return CGFloat(self.height)
    }
    
    @objc func itemDidPausePlaying(_ playerItem: AVPlayerItem) {
     
    }
    
    @objc func btnApplyMembership(sender : UIButton){
        let indexPath = IndexPath(row: sender.tag, section: 1)
        let style = ToastStyle()
        let cell = self.tableView.cellForRow(at: indexPath) as? MembershipFormCell
        if cell!.txtFirstName.text?.count == 0 || cell!.txtLastName.text?.count == 0 || cell!.txtContactNumber.text?.count == 0 || cell!.txtOccupation.text?.count == 0 || cell!.txtEmail.text?.count == 0 {
            self.view.makeToast("Please enter all fields.", duration: 3.0, position: .bottom, style: style)
            return
        }

        if(!isValidText(testStr: cell!.txtFirstName.text!)){
            self.view.makeToast("Please enter valid first name.", duration: 3.0, position: .bottom, style: style)
            return
        }

        if(!isValidText(testStr: cell!.txtLastName.text!)){
            self.view.makeToast("Please enter valid last name.", duration: 3.0, position: .bottom, style: style)
            return
        }
        
        if(!isValidPhone(testStr: cell!.txtContactNumber.text!)){
            self.view.makeToast("Please enter valid contact number.", duration: 3.0, position: .bottom, style: style)
            return
        }
        
        if(!isValidEmail(testStr: cell!.txtEmail.text!)){
            self.view.makeToast("Email format: user@mail.com", duration: 3.0, position: .bottom, style: style)
            return
        }
        
        let memberId = UserDefaults.standard.value(forKey: "memberId") as? String
        let churchName = detailsDict["name"]!.string!
        let parameters: [String: Any] = ["userId": memberId!, "churchName": churchName]
        APIHelper().post(apiUrl: GlobalConstants.APIUrls.AddChurchMember, parameters: parameters as [String : AnyObject]) { (response) in
        }
    }
    
    @objc func btnCallClicked(sender : UIButton){
        guard let number = URL(string: "tel://" + branchArr[sender.tag].cellphone) else { return }
        UIApplication.shared.open(number)
    }
    
    @objc func btnDirectionClicked(sender : UIButton){
        
        let address: String = branchArr[sender.tag].address
        let geocoder: CLGeocoder = CLGeocoder()
        // Get place marks for the address to be opened
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                //print("Error", error)
            }
            if let placemark = placemarks?.first {
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
//                let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: 1000, longitudinalMeters: 1000)
//                let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
                
//                let mapItem = MKMapItem(placemark: placemark)
//                mapItem.name = "Destination"
//                mapItem.openInMaps(launchOptions:[
//                MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center)
//                ] as [String : Any])
                var currentLocation: CLLocation!
                
                if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
                    CLLocationManager.authorizationStatus() ==  .authorizedAlways){
                    
                    currentLocation = self.locManager.location
                    let source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)))
                    source.name = "Source"
                    
                    let destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)))
                    destination.name = "Destination"
                    
                    MKMapItem.openMaps(with: [source, destination], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
                }
                
            }
        })
    }
    
    @objc func btnShareEventClicked(sender: UIButton) {
        let eventName = eventArr[sender.tag].name
        let messageToShare = "Hey, check out this cool Event: " + eventName + " - on #Preach Hub"
        let indexPath = IndexPath(row: sender.tag, section: 1)
        let cell = self.tableView.cellForRow(at: indexPath) as? EventCell
        let eventImage = cell?.imgVwEvent.image
        let activityViewController = UIActivityViewController(activityItems: [eventImage!, messageToShare], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook, UIActivity.ActivityType.postToTwitter]
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @objc func btnMoreProductClicked(sender: UIButton) {
        let ProductVC = ProductViewController.storyboardInstance()
        ProductVC!.parentId = id
        ProductVC!.categoryTitle = "All"
        ProductVC!.productList = productsArr
        ProductVC!.isChurch = true
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
            id = self.testimonyArr[index].id
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

