import MapKit

struct Marker: Identifiable, Codable {
    let id: UUID
    let name: String
    let coordinate: CLLocationCoordinate2D
    var reviews: [Review]
    
    var averageRating: Double {
        guard !reviews.isEmpty else { return 0 }
        let totalRating = reviews.reduce(0) { $0 + $1.rating }
        return Double(totalRating) / Double(reviews.count)
    }
    
    init(id: UUID = UUID(), name: String, coordinate: CLLocationCoordinate2D, reviews: [Review] = []) {
        self.id = id
        self.name = name
        self.coordinate = coordinate
        self.reviews = reviews
    }
}
