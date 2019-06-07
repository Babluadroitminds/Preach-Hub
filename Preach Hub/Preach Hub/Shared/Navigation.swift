//
//  Navigation.swift
//  CREW_APP
//
//  Created by Midhun Saleem on 29/10/18.
//  Copyright © 2018 POC. All rights reserved.
//

import UIKit
import Foundation

extension UIViewController {
    
//    func navigateToWelocomeNavigation()
//    {
////        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
////        let welcomeViewController = storyBoard.instantiateViewController(withIdentifier: "WelcomePage")// as? UINavigationController
////        self.navigationController?.pushViewController(welcomeViewController, animated: true)
//        
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let pinViewController = storyBoard.instantiateViewController(withIdentifier: "WelcomePage")
//        // self.window?.rootViewController = pinViewController
//        UIApplication.shared.keyWindow?.rootViewController = pinViewController
//        UIApplication.shared.keyWindow?.makeKeyAndVisible()
//    }
//    func navigateToWelocomePageView()
//    {
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let welcomeViewController = storyBoard.instantiateViewController(withIdentifier: "WelcomePageViewController") as! WelcomePageViewController
//        self.navigationController?.pushViewController(welcomeViewController, animated: true)
//    }
    func navigateToLogin(){
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let loginViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        let navigationController = UINavigationController(rootViewController: loginViewController)
        navigationController.isNavigationBarHidden = true
        appdelegate.window?.rootViewController = navigationController
    }
    
    func navigateToHomeScreenPage()
    {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Home", bundle:nil)
        let welcomeViewController = storyBoard.instantiateViewController(withIdentifier: "HomeTabBarViewController") as! HomeTabBarViewController
        self.navigationController?.pushViewController(welcomeViewController, animated: true)
    }
    func navigateToPastorScreenPage(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Home", bundle:nil)
        let welcomeViewController = storyBoard.instantiateViewController(withIdentifier: "ListViewController") as! ListViewController
        self.navigationController?.pushViewController(welcomeViewController, animated: true)
    }
    func navigateToPaymentPage(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Payment", bundle:nil)
        let paymentViewController = storyBoard.instantiateViewController(withIdentifier: "PaymentViewController") as! PaymentViewController
        self.navigationController?.pushViewController(paymentViewController, animated: true)
    }
    func navigateToAddShippingAddressPage()
    {
        let storyBoard : UIStoryboard = UIStoryboard(name: "CartPayment", bundle:nil)
        let paymentViewController = storyBoard.instantiateViewController(withIdentifier: "AddShippingAddressViewController") as! AddShippingAddressViewController
        self.navigationController?.pushViewController(paymentViewController, animated: true)
    }
    func navigateToCartPaymentPage()
    {
        let storyBoard : UIStoryboard = UIStoryboard(name: "CartPayment", bundle:nil)
        let paymentViewController = storyBoard.instantiateViewController(withIdentifier: "CartPaymentViewController") as! CartPaymentViewController
        self.navigationController?.pushViewController(paymentViewController, animated: true)
    }
    func navigateToAddBillingPage()
    {
        let storyBoard : UIStoryboard = UIStoryboard(name: "CartPayment", bundle:nil)
        let paymentViewController = storyBoard.instantiateViewController(withIdentifier: "AddBillingAddressViewController") as! AddBillingAddressViewController
        self.navigationController?.pushViewController(paymentViewController, animated: true)
    }
    func navigateToExistingCardPage()
    {
        let storyBoard : UIStoryboard = UIStoryboard(name: "CartPayment", bundle:nil)
        let paymentViewController = storyBoard.instantiateViewController(withIdentifier: "PaymentExistingCardViewController") as! PaymentExistingCardViewController
        self.navigationController?.pushViewController(paymentViewController, animated: true)
    }
    func navigateToFavouritesPage()
    {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Home", bundle:nil)
        let paymentViewController = storyBoard.instantiateViewController(withIdentifier: "FavouritesViewController") as! FavouritesViewController
        self.navigationController?.pushViewController(paymentViewController, animated: true)
    }
}

