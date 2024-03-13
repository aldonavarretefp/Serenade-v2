//
//  UserDetailsPPictureView.swift
//  serenadev2
//
//  Created by Alejandro Oliva Ochoa on 12/03/24.
//

import SwiftUI
import CloudKit

struct UserDetailsPPictureView: View {
    
    @StateObject var profilePicViewModel: ProfilePicViewModel = ProfilePicViewModel()
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var userViewModel: UserViewModel
    
    var body: some View {
        NavigationStack{
            ZStack{
                
                LinearGradient(colors: [colorScheme == .light ? .white : Color(hex: 0x101010), Color(hex: 0xBA55D3)], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                
                if colorScheme == .light {
                    Color.white.opacity(0.5)
                        .ignoresSafeArea()
                } else {
                    Color.black.opacity(0.8)
                        .ignoresSafeArea()
                }
                    
                
                VStack{
                    
                    Text(LocalizedStringKey("UploadProfilePictureTitle"))
                        .font(.largeTitle)
                        .bold()
                        .multilineTextAlignment(.center)
                        .padding()
                        .padding(.bottom, 20)
                    
                    Text(LocalizedStringKey("UploadProfilePictureDescription"))
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                    
                    EditableCircularProfileImage(viewModel: profilePicViewModel)
                        .scaleEffect(1.2)
                    
                    Spacer()
                    
                    ActionButton(label: LocalizedStringKey("CompleteAccount"), symbolName: "checkmark.circle.fill", fontColor: Color(hex: 0xffffff), backgroundColor: Color.accent, isShareDaily: false, isDisabled: false) {
                        var imageAsset: CKAsset?
                        // Imagen cargada
                        switch profilePicViewModel.imageState {
                        case .empty:
                            break;
                        case .loading(_):
                            break;
                        case .success(let uIImage):
                            imageAsset = profilePicViewModel.imageToCKAsset(image: uIImage)
                            guard let imageAsset, let profilePicUrl = imageAsset.fileURL else {
                                print("Couldn't bring the profileImgURL")
                                return
                                
                            }
                        case .failure(_):
                            break;
                        }
                        
                        if let user = userViewModel.user{
                            saveUserDetails(user: user, imageAsset: imageAsset)
                        }
                    }
                    
                    Button{
                        userViewModel.finishedTheProfile = true
                    } label: {
                        Spacer()
                        Text(LocalizedStringKey("Skip"))
                            .padding()
                        Spacer()
                    }
                    .foregroundStyle(.primary)
                    .padding(.horizontal)
                }
                .padding()
            }
        }
        
    }
    
    func saveUserDetails(user: User, imageAsset: CKAsset?) {
        guard var user = userViewModel.user else {
            return
        }
        user.profilePictureAsset = imageAsset
        userViewModel.updateUser(updatedUser: user)
        userViewModel.finishedTheProfile = true
        userViewModel.tagNameExists = true
    }
}

#Preview {
    UserDetailsPPictureView()
}
