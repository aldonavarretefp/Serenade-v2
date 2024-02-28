//
//  CreatePasswordView.swift
//  serenadev2
//
//  Created by Pablo Navarro Zepeda on 23/02/24.
//

import SwiftUI

struct CreatePasswordView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    let email: String
    let username: String
    @State private var password: String = ""
    @State private var passwordConfirmation: String = ""
    
    @State var darkModeToggle: Bool?
    
    var body: some View {
        ZStack {
            VStack {
                Text("Create a password")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                Text("Enter a secure password so that no one can spy on whoever you serenade.")
                    .padding()
                    .padding(.bottom)
                    .multilineTextAlignment(.center)
                ZStack {
                    Color.card
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .frame(height:50)
                    SecureField("Password", text: $password)
                        .padding()
                        .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.63))
                }
                .padding(.horizontal)
                .padding(.bottom,25)
                .shadow(color: .black.opacity(colorScheme == .light ? 0.13 : 0), radius: 12.5, x: 0, y: 4)
                
                ZStack {
                    Color.card
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .frame(height:50)
                    
                    SecureField("Confirm password", text: $passwordConfirmation)
                        .padding()
                        .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.63))
                }
                .padding(.horizontal)
                .padding(.bottom,60)
                .shadow(color: .black.opacity(colorScheme == .light ? 0.13 : 0), radius: 12.5, x: 0, y: 4)
                
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
              Gradient.Stop(color: Color(red: 0.02, green: 0.67, blue: 0.58).opacity(0.2), location: 0.00),
              Gradient.Stop(color: Color(red: 0.02, green: 0.67, blue: 0.58).opacity(0), location: 1.00),
            ],
            startPoint: UnitPoint(x: 0.5, y: 0),
            endPoint: UnitPoint(x: 0.5, y: 1)
          )
        )
    }
}

#Preview {
    CreatePasswordView(email: "", username: "")
}
