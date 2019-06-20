//
//  LevelPrediction.swift
//  captchup
//
//  Created by Celia Casagrande on 20/06/2019.
//  Copyright © 2019 iosesgi. All rights reserved.
//

import Foundation

struct LevelPrediction {
    let prediction: Prediction
    let pertinence: Double

    static func from(json: [String: Any]) -> LevelPrediction? {
        guard
            let predictionId = json["id"] as? Int,
            let predictionWord = json["word"] as? String,
            let pertinence = json["pertinence"] as? Double
            
            else {
                return nil
        }
        let prediction = Prediction(id: predictionId, word: predictionWord)
        return LevelPrediction(prediction: prediction, pertinence: pertinence)
    }
}
