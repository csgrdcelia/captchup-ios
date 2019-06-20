//
//  User.swift
//  captchup
//
//  Created by Celia Casagrande on 20/06/2019.
//  Copyright © 2019 iosesgi. All rights reserved.
//

import Foundation

struct User {
    let id: Int
    let username: String
    
    static func from(json: [String: Any]) -> User? {
        guard
            let id = json["id"] as? Int,
            let username = json["username"] as? String
        
        else {
                return nil
        }
        return User(id: id, username: username)
    }
}
