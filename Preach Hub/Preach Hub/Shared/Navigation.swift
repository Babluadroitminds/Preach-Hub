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
    func navigateToLoginPage()
    {        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let welcomeViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(welcomeViewController, animated: true)
    }
    func navigateToHomeScreenPage()
    {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Home", bundle:nil)
        let welcomeViewController = storyBoard.instantiateViewController(withIdentifier: "HomeTabBarViewController") as! HomeTabBarViewController
        self.navigationController?.pushViewController(welcomeViewController, animated: true)
    }
    func navigateToPastorScreenPage(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Home", bundle:nil)
        let welcomeViewController = storyBoard.instantiateViewController(withIdentifier: "AllPastorsViewController") as! AllPastorsViewController
        self.navigationController?.pushViewController(welcomeViewController, animated: true)
    }
    
   
}

