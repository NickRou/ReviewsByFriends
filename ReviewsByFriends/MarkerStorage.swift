import Foundation

class MarkerStorage: ObservableObject {
    @Published var markers: [Marker] = []
    
    private let markersKey = "savedMarkers"
    
    init() {
        loadMarkers()
    }
    
    func saveMarkers() {
        do {
            let data = try JSONEncoder().encode(markers)
            UserDefaults.standard.set(data, forKey: markersKey)
        } catch {
            print("Failed to save markers: \(error.localizedDescription)")
        }
    }
    
    func loadMarkers() {
        guard let data = UserDefaults.standard.data(forKey: markersKey) else { return }
        do {
            markers = try JSONDecoder().decode([Marker].self, from: data)
        } catch {
            print("Failed to load markers: \(error.localizedDescription)")
        }
    }
    
    func addMarker(_ marker: Marker) {
        markers.append(marker)
        saveMarkers()
    }
    
    func updateMarker(_ marker: Marker) {
        if let index = markers.firstIndex(where: { $0.id == marker.id }) {
            markers[index] = marker
            saveMarkers()
        }
    }
}
