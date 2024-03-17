//
//  SettingsViewModel.swift
//  serenadev2
//
//  Created by Alejandro Oliva Ochoa on 17/03/24.
//

import Foundation

final class SettingsViewModel: ObservableObject{
    
    // MARK: - Properties
    @Published var isStreamingServiceSheetDisplayed: Bool = false
    @Published var isInfoSheetDisplayed: Bool = false
    @Published var isLogOutSheetDisplayed: Bool = false
    @Published var isDeleteAccountSheetDisplayed: Bool = false
    
    
    // MARK: - Methods
    // Toggle the variable to navigate to the edit the profile view
    func toggleStreamingServiceSheet(){
        DispatchQueue.main.async{
            self.isStreamingServiceSheetDisplayed.toggle()
        }
    }
    
    // Toggle the variable to open the sheet with the info of the app
    func toggleIsInfoSheet(){
        DispatchQueue.main.async{
            self.isInfoSheetDisplayed.toggle()
        }
    }
    
    // Toggle the variable to open the sheet with the log out view
    func toggleIsLogOutSheet(){
        DispatchQueue.main.async{
            self.isLogOutSheetDisplayed.toggle()
        }
    }
    
    // Toggle the variable to open the sheet with the delete account view
    func toggleIsDeleteAccountSheet(){
        DispatchQueue.main.async{
            self.isDeleteAccountSheetDisplayed.toggle()
        }
    }
}
