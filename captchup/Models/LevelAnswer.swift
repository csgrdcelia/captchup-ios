import Foundation

struct LevelAnswer : Codable {
    let level: Level
    let prediction: Prediction?
    let user: User
}
