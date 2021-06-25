//
//  NewsModel.swift
//  VkFeed
//
//  Created by Maks Tsarevich on 23.06.21.
//

import Foundation

class NewsModel{
    
    let text: String
    let date: Int
    let id: Int
    let fromId: Int
    let countLikes: Int
    let countComments: Int
    let photo: String?
    
    init(text: String, date: Int, id: Int, fromId: Int, countLikes: Int, countComments: Int, photo: String?) {
        self.text = text
        self.date = date
        self.id = id
        self.fromId = fromId
        self.countLikes = countLikes
        self.countComments = countComments
        self.photo = photo
        
    }
    
}
