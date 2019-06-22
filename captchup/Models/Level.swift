//
//  Level.swift
//  captchup
//
//  Created by Celia Casagrande on 22/06/2019.
//  Copyright © 2019 iosesgi. All rights reserved.
//

import Foundation

struct Level {
    let id: Int
    let creator: User
    let image: String
    let levelPredictions: [LevelPrediction]
    
    static func from(json: [String: Any]) -> Level? {
        guard
            let id = json["id"] as? Int,
            let creator = json["creator"] as? User,
            let image = json["image"] as? String,
            let levelPredictions = json["levelPredictions"] as? [LevelPrediction]
            
            else {
                return nil
        }
        return level = Level(id: id, creator: creator, image: image, levelPredictions: levelPredictions)
    }
}
