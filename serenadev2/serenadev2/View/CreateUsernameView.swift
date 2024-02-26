//
//  CreateUsernameView.swift
//  serenadev2
//
//  Created by Pablo Navarro Zepeda on 23/02/24.
//

import SwiftUI

struct CreateUsernameView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    let email: String
    @State private var username: String = ""
    
    @State var darkModeToggle: Bool?
    
    var body: some View {
        ZStack {
            VStack {
                Text("Create username")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                
                Text("Choose a username for your new account. You can change it whenever you want.")
                    .padding()
                    .padding(.bottom)
                    .multilineTextAlignment(.center)
                
                ZStack {
                    Color.card
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .frame(height:50)
                    
                    TextField("Username", text: $username)
                        .padding()
                        .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.63))
                        .autocapitalization(.none)
                }
                .padding(.horizontal)
                .padding(.bottom,60)
                .shadow(color: .black.opacity(colorScheme == .light ? 0.13 : 0), radius: 12.5, x: 0, y: 4)
                
                NavigationLink(destination: CreatePasswordView(email: email, username: username)) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                        Text("Continue")
                            .foregroundStyle(.white)
                    }
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .padding()
                }
                 
                
                Spacer()
            }
        }
        .onAppear(){
            darkModeToggle = UserDefaults.standard.bool(forKey: "darkMode")
        }
        .preferredColorScheme(darkModeToggle ?? true ? .dark : .light)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
          LinearGradient(
            stops: [
                Gradient.Stop(color: Color.accentColor, location: 0.00),
                Gradient.Stop(color: Color(red: 0.02, green: 0.67, blue: 0.58).opacity(0), location: 1.00),
            ],
            startPoint: UnitPoint(x: 0.5, y: 0),
            endPoint: UnitPoint(x: 0.5, y: 1)
          )
        )
    }
}

#Preview {
    CreateUsernameView(email: "")
}
