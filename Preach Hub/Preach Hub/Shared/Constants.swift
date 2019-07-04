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
        static let memberRegister:String = "members"
        static let memberReset:String = "members/reset"
        static let verifyEmail:String = "members/findOne?filter=%@"
        static let getPlanDetails:String = "https://api.stripe.com/v1/plans"
        static let attachSubscriptionSource:String = "members/attachSubscriptionSource"
        static let chargeMember: String = "members/chargeMember"
        static let getChurches: String = "churches"
        static let getPastors: String = "pastors"
        static let getCategory: String = "categories"
        static let getProductByCategoryId: String = "products?filter=%@"
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
        static let getAllPastors: String = "https://www.jmtbiz.co.za/preach/pastorlist.json?per-page=50"
        static let getAllProducts: String = "products"
        static let getHomeDetails: String = "homes/getHome"
        static let getContinueWatchings: String = "continuewatchings?filter=%@"
        static let getPastorDetails: String = "pastors/%@?filter=%@"
        static let getCategoryByParentId: String = "categories?filter=%@"
        static let getAllProductsByParentId: String = "products?filter=%@"
        static let registerDevice: String = "memberdevices/replaceOrCreate"
        static let getChurchDetails: String = "churches/%@?filter=%@"
        static let removeMemberDevicesById: String = "memberdevices/%@/members/memberdevices"
        static let AddChurchMember: String = "churchmembers/saveChurchMember"
        static let getBanners: String = "sermons?filter=%@"
        static let continueWatchings: String = "continuewatchings"
        static let getContinueWatchingById: String = "continuewatchings?filter=%@"
        static let getMusic: String = "music"
        static let removeContinueWatchingVideo: String = "continuewatchings/%@"
        static let checkChurchMember: String = "members/%@?filter=%@"
        static let registerChurchMember: String = "churches/%@/members"
        static let getNotifications: String = "engagements"
        static let getNotificationDetails: String = "engagements/%@"
        static let cancelMembership: String = "members/cancelMemberSubscription"
        static let updateCardDetails: String = "members/updateMemberCardDetails"
    }
}
