//
//  ProfileModel.swift
//  VkFeed
//
//  Created by Maks Tsarevich on 23.06.21.
//

import Foundation

class ProfileModel{
    
    var firstname: String
    var lastname: String
    var id: Int
    
    init(firstname: String, lastname: String, id: Int) {
        self.firstname = firstname
        self.lastname = lastname
        self.id = id
    }
}
