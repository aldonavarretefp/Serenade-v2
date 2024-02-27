//
//  SearchView.swift
//  serenadev2
//
//  Created by Pablo Navarro Zepeda on 22/02/24.
//

import SwiftUI

struct SearchView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var searchText = ""
    @State private var selectedTab = "Music"
    @State private var underlineOffset: CGFloat = 0 // Offset for the underline
    
    
    private let underlineHeight: CGFloat = 2
    private let animationDuration = 0.2
    
    let musicList = [
        ContentItem(imageUrl: URL(string: "https://i.scdn.co/image/ab67616d0000b2738940ac99f49e44f59e6f7fb3"), title: "See you again (feat. Kali Uchis)", subtitle: "Tyler, The Creator, Kali Uchis", isPerson: false),
        ContentItem(imageUrl: URL(string: "https://i.scdn.co/image/ab67616d00001e02baf2a68126739ff553f2930a"), title: "Runaway", subtitle: "Kanye West", isPerson: false),
        ContentItem(imageUrl: URL(string: "https://i.scdn.co/image/ab67616d0000b273dafad44c40c08d3fbfcce20f"), title: "Entropy", subtitle: "Beach Bunny", isPerson: false)
    ]
    let peopleList = [
        ContentItem(imageUrl: URL(string: "https://www.opticalexpress.co.uk/media/1064/man-with-glasses-smiling-looking-into-distance.jpg"), title: "Fernando Fernández", subtitle: "janedoe", isPerson: true),
        ContentItem(imageUrl: URL(string: "https://i.pinimg.com/474x/98/51/1e/98511ee98a1930b8938e42caf0904d2d.jpg"), title: "Jane Smith", subtitle: "janesmith", isPerson: true),
        ContentItem(imageUrl: URL(string: "https://img.freepik.com/free-photo/young-beautiful-woman-pink-warm-sweater-natural-look-smiling-portrait-isolated-long-hair_285396-896.jpg?size=626&ext=jpg&ga=GA1.1.1700460183.1708560000&semt=ais"), title: "Alice Johnson", subtitle: "alicejohnson", isPerson: true)
    ]
    
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        // Music tab
                        Text("Music")
                            .padding(.vertical)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(selectedTab == "Music" ? colorScheme == .dark ? .white: .black : .callout)
                            .fontWeight(.semibold)
                            .onTapGesture {
                                withAnimation(.easeOut(duration: animationDuration)) {
                                    selectedTab = "Music"
                                    underlineOffset = 0 // Reset offset for the Music tab
                                }
                            }
                        
                        // People tab
                        Text("People")
                            .padding(.vertical)
                            .frame(maxWidth: .infinity)
                            .fontWeight(.semibold)
                            .foregroundColor(selectedTab == "People" ? colorScheme == .dark ? .white: .black : .callout)
                            .onTapGesture {
                                withAnimation(.easeOut(duration: animationDuration)) {
                                    selectedTab = "People"
                                    underlineOffset = geometry.size.width / 2 // Set offset for the People tab
                                }
                            }
                    }
                    .overlay(
                        Rectangle()
                            .frame(width: geometry.size.width / 2, height: underlineHeight)
                            .foregroundColor(colorScheme == .dark ? .white: .black)
                            .offset(x: underlineOffset, y: 0),
                        alignment: .bottomLeading
                    )
                    .frame(height: 50)
                    
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(filteredResults, id: \.title) { item in
                                ItemSmall(item: item, showArrow: true)
                                    .padding()
                            }
                        }
                    }
                }
                .searchable(text: $searchText)
            }
        }
        
        var filteredResults: [ContentItem] {
            if selectedTab == "Music" {
                return musicList.filter {
                    $0.title.localizedCaseInsensitiveContains(searchText) ||
                    $0.subtitle.localizedCaseInsensitiveContains(searchText) ||
                    searchText.isEmpty
                }
            } else {
                return peopleList.filter {
                    $0.title.localizedCaseInsensitiveContains(searchText) ||
                    $0.subtitle.localizedCaseInsensitiveContains(searchText) ||
                    searchText.isEmpty
                }
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
