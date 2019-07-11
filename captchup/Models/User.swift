import Foundation

struct User : Codable {
    let id: Int
    let username: String
    let password: String
    let follow: [User]
    let followedBy: [User]
}
