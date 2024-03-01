//
//  NotificationItem.swift
//  serenadev2
//
//  Created by Alejandro Oliva Ochoa on 01/03/24.
//

import SwiftUI

struct NotificationItem: View {
    var body: some View {
        HStack{
            NotificationActionButton(icon: "checkmark"){
                print("Check")
            }
            
            NotificationActionButton(icon: "xmark"){
                print("xmark")
            }
        }
    }
}

#Preview {
    NotificationItem()
}
