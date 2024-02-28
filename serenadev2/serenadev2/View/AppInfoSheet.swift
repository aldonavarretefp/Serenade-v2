//
//  AppInfoSheet.swift
//  serenadev2
//
//  Created by Gustavo Sebastian Leon Cortez on 28/02/24.
//

import SwiftUI

struct AppInfoSheet: View {
    
    @Environment(\.openURL) private var openURL
    
    let website: URL = URL(string: "https://developer.apple.com")!
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.viewBackground
                .ignoresSafeArea()
            VStack {
                HStack {
                    Text("Information")
                        .font(.title2)
                    .fontWeight(.semibold)
                    Spacer()
                }
                
                Image("AppIcon")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("Serenade")
                    .font(.title3)
                Text("1.0")
                    .foregroundStyle(.callout)
                
                GroupBox {
                    HStack {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image(systemName: "hammer")
                                    .foregroundStyle(.accent)
                                Text("Developers")
                                    .font(.body)
                            }
                            Text("Aldo Navarrete")
                            Text("Alejandro Oliva")
                            Text("Diego Núñez")
                            Text("Pablo Navarro")
                            Text("Pedro Rouin")
                            Text("Sebastian Leon")
                        }
                        .font(.subheadline)
                        Spacer()
                    }
                }
                .padding(.top)
                .backgroundStyle(.card)
                
                GroupBox {
                    HStack {
                        Image(systemName: "network")
                            .foregroundStyle(.accent)
                        Text("Website")
                        Spacer()
                        Image(systemName: "arrow.up.right")
                            .foregroundStyle(.callout)
                    }
                }
                .onTapGesture{
                    openURL(website)
                }
                .backgroundStyle(.card)
                .foregroundStyle(.primary)
            }
            .padding()
        }
    }
}

#Preview {
    AppInfoSheet()
}
