//
//  SearchViewModel.swift
//  serenadev2
//
//  Created by Pablo Navarro Zepeda on 27/02/24.
//

import Foundation
import Combine
import MusicKit

/// The SearchViewModel serves as a bridge between the MusicKit API and the SwiftUI view that displays the search results. It employs Combine for reactive programming, debouncing search inputs to enhance performance and reduce the number of API calls, and uses async/await for asynchronous network requests to fetch song data. This structure keeps the UI responsive and separates the business logic from the view code, adhering to the principles of MVVM architecture.

/// A ViewModel class responsible for handling the search functionality within the application.
/// It utilizes the MusicKit API to search for songs based on user input and manages the application's state related to the search operation.
class SearchViewModel: ObservableObject {
    // MARK: - Properties
    
    /// The search text input by the user. Observing this property allows the view to update in response to changes.
    @Published var searchText = ""
    @Published var isLoading = false
    
    /// The list of songs retrieved from the search. It's observed by the view to update the song list display.
    @Published var songs: [SongModel] = []
    
    /// A set to hold all the cancellables, i.e., the subscriptions to publishers. This is necessary to keep the subscriptions alive.
    private var cancellables = Set<AnyCancellable>()
    
    /// The delay in seconds before the search is executed, used for debouncing the search input to reduce API calls.
    private let searchDelay = 0.5
    
    // MARK: - Initializer
    
    /// Initializes the SearchViewModel, setting up the necessary bindings and subscriptions.
    init() {
        $searchText
        // Removes consecutive duplicates to prevent unnecessary searches.
            .removeDuplicates()
        // Waits for a specified time after the user stops typing before triggering the search.
            .debounce(for: .seconds(searchDelay), scheduler: RunLoop.main)
        // Subscribes to the searchText changes and triggers the music fetch operation.
            .sink { [weak self] searchText in
                self?.fetchMusic(with: searchText)
            }
        // Stores the subscription in the cancellables set.
            .store(in: &cancellables)
    }
    
    // MARK: - Methods
    
    /// Fetches music from the MusicKit API based on the current search text.
    /// - Parameter searchText: The text to search for in the MusicKit API.
    func fetchMusic(with searchText: String) {
        
        if searchText.isEmpty {
            DispatchQueue.main.async {
                self.songs = []
                self.isLoading = false
            }
            return
        }
        isLoading = true 
        
        Task {
            let status = await MusicAuthorization.request()
            switch status {
            case .authorized:
                var request = MusicCatalogSearchRequest(term: searchText, types: [Song.self])
                request.limit = 10
                do {
                    let result = try await request.response()
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.songs = result.songs.compactMap({
                            return SongModel(
                                id: $0.id.rawValue,
                                title: $0.title,
                                artists: $0.artistName,
                                artworkUrlSmall: $0.artwork?.url(width: 100, height: 100),
                                artworkUrlMedium: $0.artwork?.url(width: 800, height: 800),
                                artworkUrlLarge: $0.artwork?.url(width: 1000, height: 1000),
                                bgColor: $0.artwork?.backgroundColor,
                                priColor: $0.artwork?.primaryTextColor,
                                secColor: $0.artwork?.secondaryTextColor,
                                terColor: $0.artwork?.tertiaryTextColor,
                                quaColor: $0.artwork?.quaternaryTextColor,
                                previewUrl:$0.previewAssets?[0].url,
                                albumTitle: $0.albumTitle,
                                duration: $0.duration,
                                composerName: $0.composerName,
                                genreNames: $0.genreNames,
                                releaseDate: $0.releaseDate
                            )
                        })
                        
                    }
                } catch {
                    print("Error fetching songs: \(error)")
                }
            default:
                print("Not authorized to access MusicKit")
            }
        }
    }
}

