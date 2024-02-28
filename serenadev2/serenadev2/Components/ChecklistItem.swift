//
//  ChecklistItem.swift
//  serenadev2
//
//  Created by Gustavo Sebastian Leon Cortez on 28/02/24.
//

import SwiftUI

struct ChecklistItem: View {
    
    @State var selected: Bool
    var image: String?
    var label: String?
    
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
            selected.toggle()
        }
    }
}

#Preview {
    ChecklistItem(selected: false, image: "AppleMusicAppIcon", label: "Apple Music")
}
