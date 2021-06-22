//
//  LoginViewController.swift
//  VkFeed
//
//  Created by Maks Tsarevich on 22.06.21.
//

import UIKit
import VK_ios_sdk

class LoginViewController: UIViewController, VKSdkUIDelegate, VKSdkDelegate {
    
    // - Manager
    let userDefaultsManager = UserDefaults()
    
    // - UI
    @IBOutlet weak var LoginButton: UIButton!
    
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        print("Registration done")
    }
    
    func vkSdkUserAuthorizationFailed() {
        print("error")
    }
    
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        present(controller, animated: true, completion: nil)
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        showFeedViewController()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    @IBAction func LoginButtonAction(_ sender: Any) {
        let sdkInstance = VKSdk.initialize(withAppId: "7886393")
        sdkInstance?.register(self)
        sdkInstance?.uiDelegate = self
        let scope = ["email", "photos"]
        
        VKSdk.wakeUpSession(scope) { [weak self] (state, error) in
            if state == .authorized{
                self?.showFeedViewController()
            }else{
                VKSdk.authorize(scope)
            }
        }
    }
}
    // MARK: -
    // MARK: - Show extension

    extension LoginViewController{
        func showFeedViewController(){
            userDefaultsManager.set(true, forKey: UserDefaultConst.isLoginedKey)
            let feedVC = UIStoryboard(name: "Feed", bundle: nil).instantiateInitialViewController() as! FeedViewController
            feedVC.modalPresentationStyle = .overFullScreen
            present(feedVC, animated: true, completion: nil)
        }
        
    }

    
