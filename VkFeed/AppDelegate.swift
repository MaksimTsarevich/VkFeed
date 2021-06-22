//
//  AppDelegate.swift
//  VkFeed
//
//  Created by Maks Tsarevich on 22.06.21.
//

import UIKit
import VK_ios_sdk

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let loginVC = UIStoryboard(name: "Login", bundle: nil).instantiateInitialViewController() as! LoginViewController
        
        
        let isLogined = (UserDefaults().value(forKey: UserDefaultConst.isLoginedKey) as? Bool) ?? false
        
        if isLogined{
            window?.rootViewController = TabBarViewController()
        } else {
            window?.rootViewController = loginVC
        }
        
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        VKSdk.processOpen(url, fromApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String)
        return true
    }
}

