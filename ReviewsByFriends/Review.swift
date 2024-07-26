import Foundation

struct Review: Identifiable, Codable {
    let id: UUID
    let text: String
    let rating: Int
    
    init(id: UUID = UUID(), text: String, rating: Int) {
        self.id = id
        self.text = text
        self.rating = rating
    }
}
