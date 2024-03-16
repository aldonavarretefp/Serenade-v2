//
//  ProfilePicViewModel.swift
//  serenadev2
//
//  Created by Aldo Yael Navarrete Zamora on 07/03/24.
//

import PhotosUI
import SwiftUI

import CloudKit

class ProfilePicViewModel: ObservableObject {
    // MARK: - Profile Image
    
    enum ImageState {
        case empty
        case loading(Progress)
        case success(UIImage)
        case failure(Error)
    }
    
    enum TransferError: Error {
        case importFailed
    }
    
    struct ProfileImage: Transferable {
        let image: UIImage
        
        static var transferRepresentation: some TransferRepresentation {
            DataRepresentation(importedContentType: .image) { data in
            #if canImport(AppKit)
                guard let nsImage = NSImage(data: data) else {
                    throw TransferError.importFailed
                }
                let image = Image(nsImage: nsImage)
                return ProfileImage(image: image)
            #elseif canImport(UIKit)
                guard let uiImage = UIImage(data: data) else {
                    throw TransferError.importFailed
                }
                return ProfileImage(image: uiImage)
            #else
                throw TransferError.importFailed
            #endif
            }
        }
    }
    
    @Published private(set) var imageState: ImageState = .empty
    
    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet {
            if let imageSelection {
                let progress = loadTransferable(from: imageSelection)
                imageState = .loading(progress)
            } else {
                imageState = .empty
            }
        }
    }
    
    init(profileImageUrl: String? = nil) {
        if let urlString = profileImageUrl {
            fetchProfileImage(urlString: urlString)
        }
    }

    
    // MARK: - Private Methods
    
    private func loadTransferable(from imageSelection: PhotosPickerItem) -> Progress {
        return imageSelection.loadTransferable(type: ProfileImage.self) { result in
            DispatchQueue.main.async {
                guard imageSelection == self.imageSelection else {
                    print("Failed to get the selected item.")
                    return
                }
                switch result {
                case .success(let profileImage?):
                    self.imageState = .success(profileImage.image)
                case .success(nil):
                    self.imageState = .empty
                case .failure(let error):
                    self.imageState = .failure(error)
                }
            }
        }
    }
}

extension ProfilePicViewModel {
    func fetchProfileImage(urlString: String) {
        guard let url = URL(string: urlString) else {
            self.imageState = .empty
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.imageState = .failure(error)
                    return
                }
                
                guard let data = data, let image = UIImage(data: data) else {
                    self.imageState = .failure(TransferError.importFailed)
                    return
                }
                
                self.imageState = .success(image)
            }
        }.resume()
    }
}

extension ProfilePicViewModel {
    func imageToCKAsset(image: UIImage) -> CKAsset? {
        // Convert UIImage to Data
        guard let imageData = image.jpegData(compressionQuality: 1.0) else { return nil }
        
        // Create a temporary file URL for the CKAsset
        let tempDirectory = NSTemporaryDirectory()
        let tempURL = URL(fileURLWithPath: tempDirectory).appendingPathComponent(UUID().uuidString + ".jpg")
        
        do {
            try imageData.write(to: tempURL)
            return CKAsset(fileURL: tempURL)
        } catch {
            print("Failed to write image data to temp file: \(error)")
            return nil
        }
    }
}





struct ProfileImage: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    let imageState: ProfilePicViewModel.ImageState
    
    var body: some View {
        switch imageState {
        case .success(let image):
            Image(uiImage: image).resizable()
        case .loading:
            ProgressView()
        case .empty:
            Image(systemName: "person.fill")
                .font(.largeTitle)
                .foregroundStyle(colorScheme == .light ? .white : .black)
        case .failure:
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.largeTitle)
                .foregroundStyle(colorScheme == .light ? .white : .black)
        }
    }
}

struct CircularProfileImage: View {
    let imageState: ProfilePicViewModel.ImageState
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ProfileImage(imageState: imageState)
            .scaledToFill()
            .frame(width: 120, height: 120)
            .background (colorScheme == .light ? .black : .white)
            .clipShape(Circle())
    }
}

struct EditableCircularProfileImage: View {
    @ObservedObject var viewModel: ProfilePicViewModel
    
    var body: some View {
        
        PhotosPicker(selection: $viewModel.imageSelection,
                     matching: .images,
                     photoLibrary: .shared()){
            CircularProfileImage(imageState: viewModel.imageState)
                .overlay(alignment: .bottomTrailing) {
                    Image(systemName: "pencil.circle.fill")
                        .symbolRenderingMode(.multicolor)
                        .font(.system(size: 30))
                        .foregroundStyle(Color.accent)
                }
        }
    }
}

#Preview {
    EditableCircularProfileImage(viewModel: ProfilePicViewModel())
        
}

