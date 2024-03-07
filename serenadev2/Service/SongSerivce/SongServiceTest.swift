//
//  SongServiceTest.swift
//  serenadev2
//
//  Created by Pablo Navarro Zepeda on 28/02/24.
//
/*
import SwiftUI
import Combine

class SongViewModelTest: ObservableObject {
    @Published var song: SongModel?
    @Published var error: Error?
    
    func fetchSong(id: String, completionHandler: @escaping (SongModel) -> Void) {
        Task {
            do {
                let fetchedSong = try await SongService.fetchSongById(id)
                DispatchQueue.main.async {
                    self.song = fetchedSong
                    completionHandler(fetchedSong)
                }
            } catch {
                DispatchQueue.main.async {
                    self.error = error
                }
            }
        }
    }
}

struct SongServiceTest: View {
    //@StateObject private var viewModel = SongViewModelTest()
    @State private var inputId: String = ""
    
    var body: some View {
        VStack {
            TextField("Enter Song ID", text: $inputId)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Fetch Song") {
                viewModel.fetchSong(id: inputId) { _ in
                    
                }
            }
            .padding()

            if let song = viewModel.song {
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Title: \(song.title)")
                        Text("Artists: \(song.artists)")
                        if let url = song.artworkUrlSmall {
                            Text("Artwork URL (Small): \(url)")
                        }
                        if let url = song.artworkUrlLarge {
                            Text("Artwork URL (Large): \(url)")
                        }
                        if let duration = song.duration {
                            Text("Duration: \(duration) seconds")
                        }
                        if let composer = song.composerName {
                            Text("Composer: \(composer)")
                        }
                        Text("Genre: \(song.genreNames.joined(separator: ", "))")
                        if let releaseDate = song.releaseDate {
                            Text("Release Date: \(releaseDate.formatted())")
                        }
                        // Add more properties as needed
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            } else if viewModel.error != nil {
                Text("Failed to fetch song. Check your internet connection and try again.")
            }
        }
        .padding()
    }
}

#Preview {
    SongServiceTest()
}
*/
