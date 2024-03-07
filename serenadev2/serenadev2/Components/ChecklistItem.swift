//
//  ChecklistItem.swift
//  serenadev2
//
//  Created by Gustavo Sebastian Leon Cortez on 28/02/24.
//

import SwiftUI

struct ChecklistItem: View {
    
    @Binding var selected: Bool
    var image: String?
    var label: String?
    var key: String
    var disableIfLastOne: Bool
    
    var body: some View {
        GroupBox {
            HStack {
                if image != nil {
                    Image(image!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 60, height: 60)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                if label != nil {
                    Text(label!)
                        .foregroundStyle(.primary)
                        .padding(.horizontal, 5)
                }
                Spacer()
                Image(systemName: selected ? "checkmark.square.fill" : "square")
                    .resizable()
                    .foregroundStyle(.accent)
                    .frame(width: 20, height: 20)
                    .padding(.horizontal, 5)
            }
        }
        .backgroundStyle(.card)
        .padding(.vertical, 3)
        .onTapGesture {
            if selected && disableIfLastOne && countSelectedItems() <= 1 {
                return // No deshabilitar si solo queda una opción activa
            }
            selected.toggle()
            UserDefaults.standard.set(selected, forKey: key)
        }
    }
    
    private func countSelectedItems() -> Int {
        let selectedAppleMusic = UserDefaults.standard.bool(forKey: "selectedAppleMusic") ? 1 : 0
        let selectedSpotify = UserDefaults.standard.bool(forKey: "selectedSpotify") ? 1 : 0
        let selectedYouTubeMusic = UserDefaults.standard.bool(forKey: "selectedYouTubeMusic") ? 1 : 0
        return selectedAppleMusic + selectedSpotify + selectedYouTubeMusic
    }
}

#Preview {
    
    ChecklistItem(selected: .constant(true), image: "AppleMusicAppIcon", label: "Apple Music", key: "selectedAppleMusic", disableIfLastOne: true)
}
