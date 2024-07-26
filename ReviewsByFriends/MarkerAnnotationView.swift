import SwiftUI

struct MarkerAnnotationView: View {
    let marker: Marker
    
    var body: some View {
        VStack(spacing: 0) {
            Text(String(format: "%.1f ★", marker.averageRating))
                .font(.caption)
                .foregroundColor(.white)
                .padding(4)
                .background(Color.black.opacity(0.6))
                .clipShape(Capsule())
            
            Image(systemName: "mappin.circle.fill")
                .font(.title)
                .foregroundColor(.red)
            
            Image(systemName: "arrowtriangle.down.fill")
                .font(.caption)
                .foregroundColor(.red)
                .offset(x: 0, y: -5)
        }
    }
}
