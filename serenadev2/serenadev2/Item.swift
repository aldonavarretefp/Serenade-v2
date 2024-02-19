//
//  Item.swift
//  serenadev2
//
//  Created by Diego Ignacio Nunez Hernandez on 19/02/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
