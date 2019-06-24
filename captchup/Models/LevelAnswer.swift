//
//  LevelAnswer.swift
//  captchup
//
//  Created by Celia Casagrande on 24/06/2019.
//  Copyright © 2019 iosesgi. All rights reserved.
//

import Foundation

struct LevelAnswer : Codable {
    let level: Level
    let prediction: Prediction?
    let user: User
}
