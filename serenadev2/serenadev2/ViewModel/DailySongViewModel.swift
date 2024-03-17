//
//  DailySongViewModel.swift
//  serenadev2
//
//  Created by Alejandro Oliva Ochoa on 17/03/24.
//

import Foundation

final class DailySongViewModel: ObservableObject{
    
    // MARK: - Properties
    @Published var caption: String = ""
    @Published var characterLimit = 150
    @Published var isPresentingSearchSong = false //for modal presentation of SearchSong
    
    // MARK: - Methods
    func toggleIsPresentingSearchSong(){
        DispatchQueue.main.async{
            self.isPresentingSearchSong.toggle()
        }
    }
}
