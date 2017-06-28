//
//  User.swift
//  FacesterGram
//
//  Created by Louis Tur on 10/21/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import Foundation

internal struct User {
    internal let firstName: String
    internal let lastName: String
    internal let username: String
    internal let emailAddress: String
    internal let thumbnailURL: String
    
    init(firstName: String, lastName: String, username: String, emailAddress: String, thumbnailURL: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.username = username
        self.emailAddress = emailAddress
        self.thumbnailURL = thumbnailURL
    }
    
    init(json: [String : AnyObject]) {
        
        let name: [String : String] = json["name"] as! [String : String]
        let first: String = name["first"]!
        let last: String = name["last"]!
        
        let login: [String : String] = json["login"] as! [String : String]
        let username: String = login["username"]!
        
        let pictures: [String : String] = json["picture"] as! [String : String]
        let thumbnail: String = pictures["thumbnail"]!
        
        let email: String = json["email"] as! String
        
        self.init(firstName: first, lastName: last, username: username, emailAddress: email, thumbnailURL: thumbnail)
    }
    
    init?(failableJSON json: [String : AnyObject]) {
        // parse out name
        guard
            let name: [String : String] = json["name"] as? [String : String],
            let first: String = name["first"],
            let last: String = name["last"]
            else {
                return nil
        }
        
        // parse out user name
        guard
            let login: [String : String] = json["login"] as? [String : String],
            let username: String = login["username"]
            else {
                return nil
        }
        
        // parse out image URLs
        guard
            let pictures: [String : String] = json["picture"] as? [String : String],
            let thumbnail: String = pictures["thumbnail"]
            else {
                return nil
        }
        
        // the rest
        guard let email: String = json["email"] as? String else {
            return nil
        }
        
        self = User(firstName: first,
                    lastName: last,
                    username: username,
                    emailAddress: email,
                    thumbnailURL: thumbnail)
        
    }
}
