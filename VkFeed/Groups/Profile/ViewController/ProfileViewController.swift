//
//  ProfileViewController.swift
//  VkFeed
//
//  Created by Maks Tsarevich on 22.06.21.
//

import UIKit
import VK_ios_sdk

class ProfileViewController: UIViewController {
    
    // - UI
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    // - Data
    
    var user: ProfileModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userNameLabel.text = user.firstname + " " + user.lastname
    }
}
