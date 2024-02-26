//
//  SettingsView.swift
//  serenadev2
//
//  Created by Gustavo Sebastian Leon Cortez on 23/02/24.
//

import SwiftUI

struct SettingsView: View {
    
    @State var isStreamingServiceSheetDisplayed: Bool = false
    @State var isInfoSheetDisplayed: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Color.viewBackground
                    .ignoresSafeArea()
                VStack(spacing: 10) {
                    GroupBox {
                        NavigationLink(destination: EmptyView(), label: {
                            Image(systemName: "square.and.pencil")
                                .foregroundStyle(.accent)
                            Text("Edit profile")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.callout)
                        })
                    }
                    .backgroundStyle(.card)
                    .foregroundStyle(.primary)
                    
                    GroupBox {
                        Button(action: { isStreamingServiceSheetDisplayed = true }, label: {
                            Image(systemName: "star")
                                .foregroundStyle(.accent)
                            Text("Favorite streaming apps")
                            Spacer()
                        })
//                        .sheet(isPresented: $isStreamingServiceSheetDisplayed, content: {
//                            EmptyView()
//                        })
                    }
                    .backgroundStyle(.card)
                    .foregroundStyle(.primary)
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: { isInfoSheetDisplayed = true }, label: {
                            Image(systemName: "info.circle")
//                                .font(.title3)
//                                .symbolRenderingMode(.palette)
                                .foregroundStyle(.accent)
                                .fontWeight(.bold)
                        })
                        .foregroundStyle(.primary)
//                        .sheet(isPresented: $isInfoSheetDisplayed, content: {
//                            EmptyView()
//                        })
                    }
                }
                .toolbarBackground(.black)
                .padding()
                .font(.subheadline)
                .navigationTitle("Settings")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

#Preview {
    SettingsView()
}
