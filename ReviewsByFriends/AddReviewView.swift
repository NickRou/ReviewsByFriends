import SwiftUI

struct AddReviewView: View {
    let marker: Marker
    let onSave: (Marker) -> Void
    @State private var reviewText: String = ""
    @State private var rating: Int = 3
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Form {
            Section(header: Text("Place")) {
                Text(marker.name)
            }
            Section(header: Text("Review")) {
                TextEditor(text: $reviewText)
                    .frame(height: 100)
            }
            Section(header: Text("Rating")) {
                Picker("Rating", selection: $rating) {
                    ForEach(1...5, id: \.self) { number in
                        Text("\(number)").tag(number)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            Button("Submit Review") {
                let newReview = Review(text: reviewText, rating: rating)
                var updatedMarker = marker
                updatedMarker.reviews.append(newReview)
                onSave(updatedMarker)
                presentationMode.wrappedValue.dismiss()
            }
        }
        .navigationTitle("Add Review")
    }
}
