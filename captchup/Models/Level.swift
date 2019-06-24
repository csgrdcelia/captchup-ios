//
//  Level.swift
//  captchup
//
//  Created by Celia Casagrande on 22/06/2019.
//  Copyright © 2019 iosesgi. All rights reserved.
//

import Foundation

struct Level : Codable {
    let id: Int
    let creator: User
    let image: String
    let levelPredictions: [LevelPrediction]
}
