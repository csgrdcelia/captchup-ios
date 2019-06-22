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
            let creator = User.from(json: json["creator"] as! [String: Any]),
            let image = json["image"] as? String,
            let levelPredictions = getLevelPredictions(from: json["levelPredictions"] as? [[String: Any]] ?? [])
            
            else {
                return nil
        }
        return Level(id: id, creator: creator, image: image, levelPredictions: levelPredictions)
    }
    
    static func getLevelPredictions(from: [[String: Any]]) -> [LevelPrediction]? {
        var levelPredictions: [LevelPrediction] = []
        for levelPrediction in from {
            guard let levelPrediction = LevelPrediction.from(json: levelPrediction) else {
                continue
            }
            levelPredictions.append(levelPrediction)
        }
        return levelPredictions
    }
}
