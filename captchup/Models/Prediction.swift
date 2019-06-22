//
//  Prediction.swift
//  captchup
//
//  Created by Celia Casagrande on 20/06/2019.
//  Copyright © 2019 iosesgi. All rights reserved.
//

import Foundation

struct Prediction {
    let id: Int
    let word: String
    
    static func from(json: [String: Any]) -> Prediction? {
        guard
            let id = json["id"] as? Int,
            let word = json["word"] as? String
            
            else {
                return nil
        }
        return Prediction(id: id, word: word)
    }
}
