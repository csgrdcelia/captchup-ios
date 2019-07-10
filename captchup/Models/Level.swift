import Foundation

struct Level : Codable {
    let id: Int
    let creator: User
    let image: String
    let levelPredictions: [LevelPrediction]
}
