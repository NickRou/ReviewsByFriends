import Foundation

struct Review: Identifiable, Codable {
    let id: UUID
    let text: String
    let rating: Int
    let userId: UUID
    let username: String
    
    init(id: UUID = UUID(), text: String, rating: Int, userId: UUID, username: String) {
        self.id = id
        self.text = text
        self.rating = rating
        self.userId = userId
        self.username = username
    }
}
