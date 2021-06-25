//
//  FeedViewController.swift
//  VkFeed
//
//  Created by Maks Tsarevich on 22.06.21.
//

import UIKit
import VK_ios_sdk

class FeedViewController: UIViewController {
    
    // - UI
    @IBOutlet weak var TableView: UITableView!
    
    // - Data
    var news = [NewsModel]()
    var profiles = [ProfileModel]()
    var cells = [Cell]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
    }
}

// MARK: -
// MARK: - Show extension

extension FeedViewController{
    func showUserViewConrtoller(user: ProfileModel){
        let userVC = UIStoryboard(name: "Profile", bundle: nil).instantiateInitialViewController() as! ProfileViewController
        userVC.user = user
        present(userVC, animated: true, completion: nil)
    }
    
    func showPhotoViewController(){
        
    }
    
    func showFailedAlert(error: String){
        let alertController = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
    }
}

// MARK: -
// MARK: - Delegate

extension FeedViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        let cell = self.cells[indexPath.row]
        switch cell {
        case .profile:
            return 60
        case .post:
            return 100
        case .info:
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.cells[indexPath.row]
        if cell == .profile{
            let news = self.news[indexPath.row / 3]
            let user = getProfile(fromId: news.fromId)
            showUserViewConrtoller(user: user)
        } /*else if cell == .post{
            showPhotoViewController()
        }*/
    }
}

// MARK: -
// MARK: - DataSource

extension FeedViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let news = self.news[indexPath.row / 3]
        let cell = self.cells[indexPath.row]
        
        switch cell {
        case .profile:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.profile.rawValue, for: indexPath) as! ProfileTableViewCell
            let profile = getProfile(fromId: news.fromId)
            cell.set(news: news, profiles: profile)
            return cell
        case .post:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.post.rawValue, for: indexPath) as! PostTableViewCell
            cell.PostTextLabel.text = news.text
            return cell
        case .info:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.info.rawValue, for: indexPath) as! InfoTableViewCell
            cell.countLakes.text = String(news.countLikes)
            cell.countComments.text = String(news.countComments)
            return cell
        }
    }
}

extension FeedViewController{
    
    enum Cell: String{
        case profile = "ProfileTableViewCell"
        case post = "PostTableViewCell"
        case info = "InfoTableViewCell"
    }
    
    func configure(){
        configureVKSDK()
        configureTableView()
    }
    
    func configureTableView(){
        TableView.delegate = self
        TableView.dataSource = self
    }
    
    func configureVKSDK(){
        let sdkInstance = VKSdk.initialize(withAppId: "7886393")
        let scope = ["email", "photos"]
        
        VKSdk.wakeUpSession(scope) {[weak self] (state, error) in
            if state == .authorized{
                self?.getMyWall()
            }
        }
    }
    
    func getMyWall(){
        let getWallRequest = VKRequest(method: "wall.get", parameters: [VK_API_OWNER_ID: 183871398, VK_API_FIELDS: ["profiles", "crop_photo", "attachments"], VK_API_EXTENDED:1])
        getWallRequest?.execute(resultBlock: {(response) in
            if let json = response?.json{
                self.parse(json: json)
            }
        }, errorBlock: { [weak self] (error) in
            self?.showFailedAlert(error: error?.localizedDescription ?? "Error")
        })
    }
    
    func getProfile(fromId: Int) -> ProfileModel{
        let findedProfile = profiles.filter({ $0.id == fromId }).first
        return findedProfile ?? ProfileModel(firstname: "", lastname: "", id: 0)
    }
}

// MARK: -
// MARK: - JSON Parse

extension FeedViewController{
    func parse(json: Any){
        let dictionary = json as! [String: Any]
        
        let count = dictionary["count"] as! Int
        let news = dictionary["items"] as! [[String: Any]]
        
        var newsArray = [NewsModel]()
        for newDictionary in news{
            let text = newDictionary ["text"] as! String
            let date = newDictionary ["date"] as! Int
            let id = newDictionary ["id"] as! Int
            let fromId = newDictionary ["from_id"] as! Int
            let likes = newDictionary ["likes"] as! [String: Int]
            let countLikes = likes["count"]
            let comments = newDictionary["comments"] as! [String: Int]
            let countComments = comments["count"]
            
            var newsPhoto: String?
            if let attachments = newDictionary["attachments"] as? [[String: Any]]{
                for attachment in attachments{
                    if let photo = attachment["photo"] as? [String: Any] {
                        newsPhoto = photo["photo_604"] as? String
                    }
                }
            }
            
            let myNews = NewsModel(text: text, date: date, id: id, fromId: fromId, countLikes: countLikes ?? 0, countComments: countComments ?? 0, photo: newsPhoto)
            self.news.append(myNews)
        }
            
            let profiles = dictionary["profiles"] as! [[String: Any]]
            for profilesDictionary in profiles{
                let firstName = profilesDictionary["first_name"] as! String
                let lastName = profilesDictionary["last_name"] as! String
                let id = profilesDictionary["id"] as! Int
                
                let profile = ProfileModel(firstname: firstName, lastname: lastName, id: id)
                self.profiles.append(profile)
            }
            
            TableView.reloadData()
            configureCellsArray()
    }
    
    func configureCellsArray(){
        for new in news{
            cells.append(.profile)
            if !new.text.isEmpty{
                cells.append(.post)
            }
            cells.append(.info)
        }
    }
        
}
