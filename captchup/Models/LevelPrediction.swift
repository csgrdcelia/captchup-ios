//
//  LevelPrediction.swift
//  captchup
//
//  Created by Celia Casagrande on 20/06/2019.
//  Copyright © 2019 iosesgi. All rights reserved.
//

import Foundation

struct LevelPrediction : Codable {
    let prediction: Prediction
    let pertinence: Double

    static func from(json: [String: Any]) -> LevelPrediction? {
        guard
            let prediction = Prediction.from(json: json["prediction"] as! [String: Any]),
            let pertinence = json["pertinence"] as? Double
            
            else {
                return nil
        }
        return LevelPrediction(prediction: prediction, pertinence: pertinence)
    }
}
