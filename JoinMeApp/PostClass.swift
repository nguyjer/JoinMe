//
//  PostClass.swift
//  JoinMeApp
//
//  Created by jeremy nguyen on 7/22/24.
//

import Foundation

public class PostClass: NSObject {
    let username:String
    let location:String
    let descript:String
    let date:String
    var users:[String]
    
    init(username: String, location: String, descript: String, date: String, users: [String]) {
        self.username = username
        self.location = location
        self.descript = descript
        self.date = date
        self.users = users
    }
}
