//
//  AppDelegate.swift
//  PasswordLock
//
//  Created by r a a j on 26/06/2025.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let vc = SplashVC()
        
        // Embed the view controller in a navigation controller
        let navController = UINavigationController(rootViewController: vc)
        // Set up the window
        vc.navigationController?.navigationBar.isHidden = true
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        
        
        //MARK: - ACCROSS APP CUSTOMIZATION
        // show alerts, menu everthing in Light mode
//        window?.overrideUserInterfaceStyle = .light
//        window?.tintColor = .white
        
        return true
    }
}
