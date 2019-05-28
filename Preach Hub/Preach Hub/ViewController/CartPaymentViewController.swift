//
//  CartPaymentViewController.swift
//  Preach Hub
//
//  Created by Adroitminds on 28/05/19.
//  Copyright © 2019 AdroitMinds. All rights reserved.
//

import UIKit

class CartPaymentViewController: UIViewController {
    @IBOutlet weak var viewDot: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDot.layer.borderColor = UIColor.clear.cgColor
        viewDot.layer.borderWidth = 2.0
        viewDot.layer.cornerRadius = 10.0
         viewDot.addViewDashedBorder(view: viewDot)

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension UIView {
    func addViewDashedBorder(view : UIView) {
        let color = UIColor.gray.cgColor
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let shapeRect = CGRect(x: 0, y: 0, width: view.layer.frame.width - 40 , height: view.layer.frame.height)
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: view.layer.frame.width/2 - 20, y: view.layer.frame.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 2
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [6,3]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 5).cgPath
        shapeLayer.layoutIfNeeded()
        self.layer.addSublayer(shapeLayer)
    }
}
