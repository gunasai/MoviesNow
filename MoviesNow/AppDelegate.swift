//
//  AppDelegate.swift
//  MoviesNow
//
//  Created by Gunasai Garapati on 2/5/19.
//  Copyright © 2019 Gunasai Garapati. All rights reserved.
//

import UIKit
import Stripe
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    
    
    func checkIfFirstLaunch() {
        if let isLoggedIn = UserDefaults.standard.value(forKey: "isLoggedIn"), isLoggedIn as! Bool == true {
            // Navigate to TabBarController
            let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewControlleripad : UIViewController = mainStoryboardIpad.instantiateViewController(withIdentifier: "TabController") as UIViewController
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window?.rootViewController = initialViewControlleripad
            self.window?.makeKeyAndVisible()
        }
        
        else {
            print("This is the first launch ever!")
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
            UserDefaults.standard.synchronize()
        }
    }

    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        checkIfFirstLaunch()
        UINavigationBar.appearance().barTintColor = UIColor(red:1.00, green:0.32, blue:0.32, alpha:1.0)
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        UINavigationBar.appearance().largeTitleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.white]


        STPPaymentConfiguration.shared().publishableKey = Constants.publishableKey
        FirebaseApp.configure()

        return true
    }


    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        if components?.scheme == "moviesnow" && components?.path == "authenticate" {
            let loginVC = window?.rootViewController as! LoginViewController
            
            TMDBClient.createSessionId(completionHandler: loginVC.handleSessionResponse(success:error:))
        }
        
        return true
    }

}

