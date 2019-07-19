//
//  Extensions.swift
//  Preach Hub
//
//  Created by Sajeev S L on 16/05/19.
//  Copyright © 2019 AdroitMinds. All rights reserved.
//

import Foundation
import UIKit
import Toast_Swift
import SDWebImage
import SideMenu
import QuartzCore

extension UIViewController : UIGestureRecognizerDelegate, UITextFieldDelegate {
    
    func applyShadow(view: UIView) {
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOpacity = 0.4
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 4
    }
    func applyBlueShadow(view : UIView){
        view.layer.shadowColor = UIColor(red: 62.0/255.0, green: 72.0/255.0, blue: 126.0/255.0, alpha: 1.0).cgColor
        view.layer.shadowOpacity = 0.4
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 10
    }
    func applyRoundViewCorner(view : UIView){
        view.layer.cornerRadius = 30.0
    }
    func applyRoundButtonCorner(button : UIButton){
        button.backgroundColor = .clear
        button.layer.cornerRadius = 30.0
        button.layer.borderWidth = 2.0
        button.layer.borderColor = UIColor.white.cgColor
    }
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }
    func popUpInProgress(){
        self.view.makeToast("In Progress..", duration: 3.0, position: .center)
    }
    
    func alertErrorMsg(_ errorMsg: String){
        let alert = UIAlertController(title: "Alert", message: errorMsg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {action in
        }
        ))
        self.present(alert, animated: true, completion: nil)
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if(touch.view != nil && touch.view! is UIButton){
            return false
        }
        
        return true
    }
    
    @IBAction func onMenuTap(_ sender: Any) {
        if(SideMenuManager.default.menuLeftNavigationController != nil){
            present(SideMenuManager.default.menuLeftNavigationController!, animated: true)
        }
    }
    
    @objc func dismissKeyboard(_sender: UIGestureRecognizer) {
        view.endEditing(true)
    }
    
    func UTCToLocal(date:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat =  "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        return dateFormatter.string(from: dt!)
    }
    
    func isValidText(testStr:String) -> Bool {
        let myCharSet=CharacterSet(charactersIn:"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ ")
        let output: String = testStr.trimmingCharacters(in: myCharSet.inverted)
        let isValid: Bool = (testStr == output)
        return isValid
    }
    
    func convertToString(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let dateFromString = dateFormatter.date(from: dateString)
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "MMM d, yyyy"
        let stringFromDate = dateFormatter2.string(from: dateFromString!)
        return stringFromDate
    }
    
    @IBAction func btnNotificationClicked(_ sender: Any) {
        self.navigateToNotificationView()
    }
    
    @IBAction func unwindSegue(_ sender: UIStoryboardSegue){
        
    }
    func navigateToNotificationView(){
        //let storyBoard : UIStoryboard = UIStoryboard(name: "Notification", bundle:nil)
        // let notificationViewController = storyBoard.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
        // self.navigationController?.pushViewController(notificationViewController, animated: true)
    }
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    func forTrailingZero(temp: Double) -> String {
        let tempVar = String(format: "%g", temp)
        return tempVar
    }
    
    func isValidPassword(testStr:String) -> Bool {
        let regularExpression = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{6,}"
        let passwordValidation = NSPredicate.init(format: "SELF MATCHES %@", regularExpression)
        return passwordValidation.evaluate(with: testStr)
    }

}
extension UITabBar{
    func inActiveTintColor() {
        if let items = items{
            for item in items{
                item.image =  item.image?.withRenderingMode(.alwaysOriginal)
            }
        }
    }
}
extension UIImageView {
    func setNotificationProfileImage(imageView : UIImageView){
        imageView.sd_setImage(with: URL.init(string: UserDefaults.standard.string(forKey: "ProfilePicture") != nil ? UserDefaults.standard.string(forKey: "ProfilePicture")! : "ic_dummy_user.png"), placeholderImage: UIImage.init(named: "ic_dummy_user.png"))
        imageView.layer.cornerRadius = 15.0
        imageView.clipsToBounds = true
    }
}

extension UIButton{
    func applyGradient(colors: [CGColor], btn: UIButton){
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame =  btn.bounds
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        btn.clipsToBounds = true
        btn.layer.insertSublayer(gradientLayer, at: 0)
    }
}
extension UIView {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    func addDashedBorder() {
//        let color = UIColor.black.cgColor
        
//        let shapeLayer:CAShapeLayer = CAShapeLayer()
//        let frameSize = self.frame.size
//        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
//
//        shapeLayer.bounds = shapeRect
//        shapeLayer.position = CGPoint(x: frameSize.width/2 , y: frameSize.height/2)
//        shapeLayer.fillColor = UIColor.clear.cgColor
//        shapeLayer.strokeColor = color
//        shapeLayer.lineWidth = 2
//        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
//        shapeLayer.lineDashPattern = [4,2]
//        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 9).cgPath
//
//        self.layer.addSublayer(shapeLayer)
        
        var yourViewBorder = CAShapeLayer()
        yourViewBorder.strokeColor = UIColor.black.cgColor
        yourViewBorder.lineDashPattern = [2, 2]
        yourViewBorder.frame = CGRect(x: self.bounds.origin.x, y: self.bounds.origin.y, width: self.bounds.size.width - 40, height: self.bounds.size.height)
        yourViewBorder.fillColor = nil
        yourViewBorder.path = UIBezierPath(rect: CGRect(x: self.bounds.origin.x, y: self.bounds.origin.y, width: self.bounds.size.width - 20, height: self.bounds.size.height)).cgPath
        self.layer.addSublayer(yourViewBorder)
    }
}

extension UIColor {
    convenience init(hex: String) {
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var alpha: CGFloat = 1.0
        var hex:   String = hex
        
        if hex.hasPrefix("#") {
            let index = hex.index(hex.startIndex, offsetBy: 1)
            hex = String(hex[index...])
        }
        
        let scanner = Scanner(string: hex)
        var hexValue: CUnsignedLongLong = 0
        if scanner.scanHexInt64(&hexValue) {
            switch (hex.characters.count) {
            case 3:
                red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
                green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
                blue  = CGFloat(hexValue & 0x00F)              / 15.0
            case 4:
                red   = CGFloat((hexValue & 0xF000) >> 12)     / 15.0
                green = CGFloat((hexValue & 0x0F00) >> 8)      / 15.0
                blue  = CGFloat((hexValue & 0x00F0) >> 4)      / 15.0
                alpha = CGFloat(hexValue & 0x000F)             / 15.0
            case 6:
                red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
                green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
                blue  = CGFloat(hexValue & 0x0000FF)           / 255.0
            case 8:
                red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
            default:
                print("Invalid RGB string, number of characters after '#' should be either 3, 4, 6 or 8", terminator: "")
            }
        } else {
            print("Scan hex error")
        }
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
}

extension String {
    
    init?(htmlEncodedString: String) {
        guard let data = htmlEncodedString.data(using: .utf8) else {
            return nil
        }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        guard let attributedString = try? NSAttributedString(data: data, options: options , documentAttributes: nil) else {
            return nil
        }
        self.init(attributedString.string)
    }
    
}

extension UICollectionView {
    func scrollToNextItem() {
        let contentOffset = CGFloat(floor(self.contentOffset.x + self.bounds.size.width))
        self.moveToFrame(contentOffset: contentOffset)
    }
    
    func scrollToPreviousItem() {
        let contentOffset = CGFloat(floor(self.contentOffset.x - self.bounds.size.width))
        self.moveToFrame(contentOffset: contentOffset)
    }
    
    func moveToFrame(contentOffset : CGFloat) {
        self.setContentOffset(CGPoint(x: contentOffset, y: self.contentOffset.y), animated: true)
    }
}
