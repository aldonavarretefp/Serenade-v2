//
//  CreateAccountView.swift
//  serenadev2
//
//  Created by Pablo Navarro Zepeda on 23/02/24.
//

import SwiftUI

struct CreateAccountView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @State private var email: String = ""
    
    @State var darkModeToggle: Bool?
    
    var body: some View {
        ZStack {
            VStack {
                
                Image(colorScheme == .dark ? "icons-login-dark" : "icons-login-light")

                .cornerRadius(10)
                
                Text("Create an account to start serenading")
                  .bold()
                  .font(.largeTitle)
                  .multilineTextAlignment(.center)
                
                NavigationLink(destination: CreateUsernameView(email: email)) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundStyle(.black)
                        
                        HStack {
                            Image(systemName: "apple.logo")
                                .foregroundStyle(.white)
                                .padding()
                            
                            Text("Continue with Apple")
                                .foregroundStyle(.white)
                                .bold()
                        }
                       
                    }
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .padding()
                }
                
                HStack {
                    VStack{
                        Divider()
                            .frame(height: 0.5)
                            .background(.gray)
                            .padding(.horizontal)
                    }
                    
                    Text("o")
                        .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.63))
                        .fontWeight(.thin)

                    VStack{
                        Divider()
                            .frame(height: 0.5)
                            .background(.gray)
                            .padding(.horizontal)
                    }
                }
                .padding()
                
                ZStack {
                    Color.card
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .frame(height:50)
                    
                    TextField("Email", text: $email)
                        .padding()
                        .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.63))
                        .autocapitalization(.none)
                }
                .padding(.horizontal)
                .padding(.bottom,100)
                .shadow(color: .black.opacity(colorScheme == .light ? 0.13 : 0), radius: 12.5, x: 0, y: 4)
                                
                NavigationLink(destination: CreateUsernameView(email: email)) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                        Text("Continue")
                            .foregroundStyle(.white)
                    }
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .padding()
                }
                
                HStack {
                    Text("Already have an account?")
                    Button(action: {
                        
                    }, label: {
                        Text("Login one!")
                    })
                }
               
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
    CreateAccountView()
}
