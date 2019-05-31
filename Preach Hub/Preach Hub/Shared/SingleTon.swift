//
//  SingleTon.swift
//  Preach Hub
//
//  Created by Divya on 29/05/19.
//  Copyright © 2019 AdroitMinds. All rights reserved.
//

import Foundation

class SingleTon
{
    static let shared = SingleTon()
        
    var firstNameShipping = ""
    var lastNameShipping = ""
    var addressShipping = ""
    var streeLine2Shipping = ""
    var emailShipping = ""
    var cityShipping = ""
    var postalCodeShipping = ""
    var stateShipping = ""
    var countryShipping = ""
    var phoneNumberShipping = ""
    
    var nameBilling = ""
    var streetBilling = ""
    var streetLine2Billing = ""
    var cityBilling = ""
    var postalCodeBilling = ""
    var stateBilling = ""
    var countryBilling = ""
    var phoneNumberBilling = ""
}
