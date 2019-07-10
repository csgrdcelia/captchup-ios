import Foundation

struct Prediction : Equatable, Codable {
    let id: Int
    let word: String
    
    static func ==(prediction1: Prediction, prediction2: Prediction) -> Bool {
        return prediction1.id == prediction2.id
    }
    
    
}
