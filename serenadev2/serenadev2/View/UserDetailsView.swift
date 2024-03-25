//
//  UserDetailsView.swift
//  serenadev2
//
//  Created by Pablo Navarro Zepeda on 05/03/24.
//
import Foundation
import SwiftUI

struct UserDetailsView: View {
    
    // MARK: - ViewModel
    @EnvironmentObject private var userViewModel: UserViewModel
    @StateObject private var userDetailsViewModel = UserDetailsViewModel()
    @StateObject private var loadingStateViewModel: LoadingStateViewModel = LoadingStateViewModel()
    
    // MARK: - Environment properties
    @Environment(\.colorScheme) var colorScheme
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack{
                
                // Background of the view
                LinearGradient(colors: [colorScheme == .light ? .white : Color(hex: 0x101010), Color(hex: 0xBA55D3)], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                if colorScheme == .light {
                    Color.white.opacity(0.5)
                        .ignoresSafeArea()
                } else {
                    Color.black.opacity(0.8)
                        .ignoresSafeArea()
                }
                
                VStack (){
                    // Title of the view
                    Text(LocalizedStringKey("CompleteYourProfile"))
                        .font(.largeTitle)
                        .bold()
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    // Description of the view
                    Text(LocalizedStringKey("FillInYourDetails"))
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 40)
                    
                    // Form
                    VStack(alignment: .leading, spacing: 40){
                        VStack(spacing: 20){
                            // Text field for the user to put his name
                            TextField("", text: $userDetailsViewModel.name)
                                .placeholder(when: userDetailsViewModel.name.isEmpty) {
                                    Text(LocalizedStringKey("Name"))
                                        .foregroundColor(.gray)
                                }
                                .foregroundStyle(.black)
                                .padding()
                                .background(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .disableAutocorrection(true)
                            
                            // Text field for the user to put his username
                            TextField("", text: $userDetailsViewModel.tagname)
                                .placeholder(when: userDetailsViewModel.tagname.isEmpty) {
                                    Text(LocalizedStringKey("Username"))
                                        .foregroundColor(.gray)
                                }
                                .foregroundStyle(.black)
                                .padding()
                                .background(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .onChange(of: userDetailsViewModel.tagname) { oldValue, newValue in
                                    userDetailsViewModel.tagname = newValue.lowercased()
                                }
                            
                            // If there's an error display it
                            if userDetailsViewModel.error != ""{
                                HStack{
                                    Spacer()
                                    
                                    Image(systemName: "info.circle")
                                    Text(userDetailsViewModel.error)
                                    Spacer()
                                }
                                .font(.footnote)
                                .foregroundStyle(.red)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    // Button to go to the next part
                    ActionButton(label: "Next", symbolName: "arrow.forward.circle.fill", fontColor: Color(hex: 0xffffff), backgroundColor: Color(hex: 0xBA55D3), isShareDaily: false, isDisabled: loadingStateViewModel.isLoading || userDetailsViewModel.tagname == "" || userDetailsViewModel.name == "" || userDetailsViewModel.tagname.containsEmoji, isLoading: loadingStateViewModel.isLoading) {
                        loadingStateViewModel.isLoading = true
                        print("Verify username availability")
                        userDetailsViewModel.verifyUsernameAvailability(userViewModel: userViewModel) { isSuccess, errorMessage in
                                loadingStateViewModel.isLoading = false
                            print("Verify username availability loading false")
                                if isSuccess {
                                    userDetailsViewModel.saveUserDetails(userViewModel: userViewModel)
                                    userDetailsViewModel.isLinkActive = true
                                    print("Verify username availability save User Details")
                                } else {
                                    withAnimation {
                                        userDetailsViewModel.error = errorMessage
                                    }
                                }
                            }
                    }
                    
                    // Navigation link to go to the user details profile picture view
                    NavigationLink(destination: UserDetailsPPictureView(), isActive: $userDetailsViewModel.isLinkActive) {
                        EmptyView()
                    }
                }
                .padding()
            }
            .onAppear {
                if let userName = userViewModel.user?.name {
                    userDetailsViewModel.name = userName
                }
            }
        }
    }
}


