import SwiftUI
import MapKit

struct ContentView: View {
    @StateObject private var searchCompleter = SearchCompleter()
    @StateObject private var markerStorage = MarkerStorage()
    @StateObject private var userManager = UserManager()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.3, longitude: -122.0),
        span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
    )
    @State private var selectedMarker: Marker?
    @State private var showingReviewSheet = false
    @State private var showingSuggestions = false
    @State private var showingReviews = false
    @State private var showingLoginView = true  // New state variable

    var body: some View {
        Group {
            if showingLoginView {
                LoginView(userManager: userManager, showingLoginView: $showingLoginView)
            } else {
                mainView
            }
        }
    }

    var mainView: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchCompleter.searchText) {
                    showingSuggestions = true
                }
                if showingSuggestions && !searchCompleter.suggestions.isEmpty {
                    List(searchCompleter.suggestions, id: \.self) { suggestion in
                        SuggestionRow(suggestion: suggestion)
                            .onTapGesture {
                                searchCompleter.searchText = suggestion.title
                                showingSuggestions = false
                                performSearch(for: suggestion)
                            }
                    }
                } else {
                    Map(coordinateRegion: $region, annotationItems: markerStorage.markers) { marker in
                        MapAnnotation(coordinate: marker.coordinate) {
                            MarkerAnnotationView(marker: marker)
                                .onTapGesture {
                                    selectedMarker = marker
                                    showingReviews = true
                                }
                        }
                    }
                    .edgesIgnoringSafeArea(.bottom)
                }
            }

            .sheet(isPresented: $showingReviewSheet) {
                if let marker = selectedMarker {
                    NavigationView {
                        AddReviewView(marker: marker, userManager: userManager) { updatedMarker in
                            markerStorage.updateMarker(updatedMarker)
                            selectedMarker = updatedMarker
                        }
                    }
                }
            }
            .sheet(isPresented: $showingReviews) {
                if let marker = selectedMarker {
                    NavigationView {
                        ReviewsView(marker: marker)
                            .navigationBarItems(trailing: Button("Add Review") {
                                showingReviews = false
                                showingReviewSheet = true
                            })
                    }
                }
            }
            .navigationTitle("Map Reviews")
            .navigationBarItems(trailing: Button("Logout") {
                userManager.logout()
                showingLoginView = true  // Show login view on logout
            })
        }
        .onChange(of: searchCompleter.searchText) { newValue in
            showingSuggestions = !newValue.isEmpty
        }
    }

    func performSearch(for suggestion: MKLocalSearchCompletion) {
        let searchRequest = MKLocalSearch.Request(completion: suggestion)
        let search = MKLocalSearch(request: searchRequest)
        search.start { response, error in
            guard let response = response else {
                print("Error: \(error?.localizedDescription ?? "Unknown error").")
                return
            }

            if let mapItem = response.mapItems.first {
                let newMarker = Marker(name: mapItem.name ?? "Unknown Place", coordinate: mapItem.placemark.coordinate)
                markerStorage.addMarker(newMarker)
                region.center = mapItem.placemark.coordinate
                selectedMarker = newMarker
                showingReviewSheet = true
            }
        }
    }
}
