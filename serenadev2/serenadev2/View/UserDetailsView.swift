//
//  UserDetailsView.swift
//  serenadev2
//
//  Created by Pablo Navarro Zepeda on 05/03/24.
//
import Foundation
import SwiftUI

struct UserDetailsView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var userViewModel: UserViewModel
    
    @State private var name: String = ""
    @State var tagname: String = ""
    @State var tagNameRepeated: Bool = false
    
    var body: some View {
        NavigationView {
            
            ZStack{
                
                LinearGradient(colors: [Color(hex: 0xBA55D3), Color(hex: 0x101010)], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                
                VStack (){
                    Text(LocalizedStringKey("CompleteYourProfile"))
                        .font(.largeTitle)
                        .bold()
                        .multilineTextAlignment(.center)
                        .padding()
                        .padding(.bottom, 20)
                    
                    Text(LocalizedStringKey("FillInYourDetails"))
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 40)
                    
                    VStack(alignment: .leading, spacing: 40){
                        VStack(spacing: 20){
                            TextField("", text: $name)
                                .placeholder(when: name.isEmpty) {
                                    Text(LocalizedStringKey("Name"))
                                        .foregroundColor(.gray)
                                }
                                .foregroundStyle(.black)
                                .padding()
                                .background(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .disableAutocorrection(true)
                            
                            
                            TextField("", text: $tagname)
                                .placeholder(when: tagname.isEmpty) {
                                    Text(LocalizedStringKey("Username"))
                                        .foregroundColor(.gray)
                                }
                                .foregroundStyle(.black)
                                .padding()
                                .background(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .autocapitalization(.none)
                                .onChange(of: tagname) { oldValue, newValue in
                                    tagname = newValue.lowercased()
                                }
                        }
                    }
                    
                    Spacer()
                    
                    ActionButton(label: LocalizedStringKey("CompleteAccount"), symbolName: "arrow.forward.circle.fill", fontColor: Color(hex: 0xffffff), backgroundColor: Color(hex: 0xBA55D3), isShareDaily: false, isDisabled: tagname == "" || name == "" || tagname.containsEmoji) {
                        saveUserDetails()
                    }
                }
                .padding()
            }
            .onAppear {
                if let userName = userViewModel.user?.name {
                    name = userName
                }
            }
        }
        .foregroundStyle(.white)
    }
    
    private func saveUserDetails() {
        tagname = tagname.formattedForTagName
        userViewModel.searchUsers(tagname: tagname) { users in
            
            guard let users = users else { return }
            
            if(!users.isEmpty) {
                self.tagNameRepeated = true
                return
            } else {
                self.tagNameRepeated = false
                guard var user = userViewModel.user else {
                    print("No user in DB")
                    return
                }
                user.tagName = tagname
                user.name = name
                userViewModel.tagNameExists = true
                userViewModel.updateUser(updatedUser: user)
            }
        }
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            
            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
}
