import MapKit
import SwiftUI

struct SuggestionRow: View {
    let suggestion: MKLocalSearchCompletion
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(suggestion.title)
                .font(.headline)
            Text(suggestion.subtitle)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
}
