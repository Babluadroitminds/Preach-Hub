//
//  Constants.swift
//  Preach Hub
//
//  Created by Sajeev S L on 16/05/19.
//  Copyright © 2019 AdroitMinds. All rights reserved.
//

import Foundation
import UIKit

struct GlobalConstants {
    struct APIUrls {
        static let baseUrl:String = ""
        static let apiBaseUrl:String = "https://preachapi.herokuapp.com/api/"
        static let websiteLink:String = "http://www.preachhub.net"
        static let memberLogin:String = "members/login"
        static let memberRegister:String = "members/savemember"
        static let memberReset:String = "members/reset"
        static let verifyEmail:String = "members/findOne?filter=%@"
        static let getPlanDetails:String = "https://api.stripe.com/v1/plans"
        static let attachSubscriptionSource:String = "members/attachSubscriptionSource"
        static let chargeMember: String = "members/chargeMember"
        static let getChurches: String = "churches"
        static let getPastors: String = "pastors"
        static let getStores: String = "categories"
        static let getProduct: String = "products?filter=%@"
        static let getProductById: String = "products/%@?filter=%@"
        static let getPreachStatistics: String = "https://www.jmtbiz.co.za/preach/statistics.json"
        static let sendOrders: String = "orders/createOrder"
        static let sendOrderDetails: String = "orderdetails"
        static let memberDetails: String = "members/%@"
        static let shippingDetails: String = "shippings"
        static let confirmOrdersById: String = "orders/%@"
        static let memberPayByCard: String = "members/MemberPayByCard"
        static let getOrdersByMemberId: String = "orders?filter=%@"
        static let getOrderDetailsById: String = "orders/%@/orderdetail?filter=%@"
    }
}
