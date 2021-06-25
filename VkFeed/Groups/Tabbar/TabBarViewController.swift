//
//  TabBarViewController.swift
//  VkFeed
//
//  Created by Maks Tsarevich on 22.06.21.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
    }

}
// MARK: -
// MARK: - Configure

extension TabBarViewController{
    
    func configure(){
        configureViewControllers()
    }
    
    func configureViewControllers(){
        
        self.tabBarController?.restorationIdentifier = "TabBarViewController"
        let feedVC = UIStoryboard (name: "Feed", bundle: nil).instantiateInitialViewController() as! FeedViewController
        
        let firstBarItem = UITabBarItem()
        firstBarItem.image = UIImage(named: "feed")
        firstBarItem.selectedImage = UIImage(named: "feed")
        feedVC.tabBarItem = firstBarItem
        
        let profileVC = UIStoryboard (name: "Profile", bundle: nil).instantiateInitialViewController() as! ProfileViewController
        
        let secondBarItem = UITabBarItem()
        secondBarItem.image = UIImage(named: "profile")
        secondBarItem.selectedImage = UIImage(named: "profile")
        profileVC.tabBarItem = secondBarItem
        
        viewControllers = [feedVC, profileVC]
    }
}
