//
//  AppInfoSheet.swift
//  serenadev2
//
//  Created by Gustavo Sebastian Leon Cortez on 28/02/24.
//

import SwiftUI

struct AppInfoSheet: View {
    
    // MARK: - Environment properties
    @Environment(\.openURL) private var openURL
    
    // MARK: - Properties
    let website: URL = URL(string: "https://developer.apple.com")!
    
    // MARK: - Body
    var body: some View {
        ZStack(alignment: .top) {
            
            // Background of the view
            Color.viewBackground
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text(LocalizedStringKey("Information"))
                        .font(.title2)
                    .fontWeight(.semibold)
                    Spacer()
                }
                
                // App logo and info
                Image("AppLogo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("Serenade")
                    .font(.title3)
                Text("1.2.14")
                    .foregroundStyle(.callout)
                
                // Info of the developers
                GroupBox {
                    HStack {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image(systemName: "hammer")
                                    .foregroundStyle(.accent)
                                Text(LocalizedStringKey("Developers"))
                            }
                            .padding(.bottom, 5)
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
                
                // Website
                GroupBox {
                    HStack {
                        Image(systemName: "network")
                            .foregroundStyle(.accent)
                        Text(LocalizedStringKey("Website"))
                        Spacer()
                        Image(systemName: "arrow.up.right")
                            .foregroundStyle(.callout)
                    }
                }
                .onTapGesture{ // on tap open the website
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
