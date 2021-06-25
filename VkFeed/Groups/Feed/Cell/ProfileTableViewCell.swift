//
//  ProfileTableViewCell.swift
//  VkFeed
//
//  Created by Maks Tsarevich on 23.06.21.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        photoImageView.contentMode = .scaleAspectFit
    }
    
    func set(news: NewsModel, profiles: ProfileModel){
        nameLabel.text = profiles.firstname + " " + profiles.lastname
        var date = Date(timeIntervalSince1970: TimeInterval(news.date))
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm"
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale(identifier: "MMM d, h:mm a")
        dateLabel.text = formatter.string(from: date)
    }
}
