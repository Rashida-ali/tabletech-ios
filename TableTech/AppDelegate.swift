//
//  AppDelegate.swift
//  TableTech
//
//  Created by Apple on 05/04/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.callRootView()
        
        return true
    }

  


}

extension AppDelegate {
    
    func callRootView(){
        
        let _window = UIWindow(frame: UIScreen.main.bounds)
        window = _window
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "loginViewController") as! loginViewController
        let rootViewController = initialViewController
        let navigationController = UINavigationController()
        navigationController.navigationBar.isHidden = true
        navigationController.viewControllers = [rootViewController]
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
    }
}
