//
//  SongViewModel.swift
//  serenadev2
//
//  Created by Aldo Yael Navarrete Zamora on 29/02/24.
//

import Foundation
import SwiftUI

class SongViewModel: ObservableObject {
    @Published var songs = [SongModel]()
    
    init() {}
}
