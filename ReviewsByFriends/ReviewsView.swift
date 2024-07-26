import SwiftUI

struct ReviewsView: View {
    let marker: Marker
    
    var body: some View {
        List {
            Section(header: Text("Average Rating")) {
                HStack {
                    StarRatingView(rating: Int(round(marker.averageRating)))
                    Text(String(format: "%.1f", marker.averageRating))
                        .font(.headline)
                }
            }
            
            Section(header: Text("Reviews")) {
                ForEach(marker.reviews) { review in
                    VStack(alignment: .leading) {
                        StarRatingView(rating: review.rating)
                        Text(review.text)
                            .font(.body)
                    }
                }
            }
        }
        .navigationTitle(marker.name)
    }
}
