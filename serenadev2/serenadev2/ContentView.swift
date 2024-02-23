//
//  ContentView.swift
//  serenadev2
//
//  Created by Diego Ignacio Nunez Hernandez on 19/02/24.
//

import SwiftUI
import SwiftData
import CloudKit

struct ContentView: View {
//    @Environment(\.modelContext) private var modelContext
//    @Query private var items: [Item]
    
    @StateObject var userViewModel: UserViewModel = UserViewModel()

    var body: some View {
        NavigationSplitView {
            List {
                
                Button(action: {
                    Task {
                        await userViewModel.saveUser(user: mockedUser)
                    }
                    
                }, label: {
                    Text("Save User")
                })
                
                Button {
                    Task {
                        guard let user = await userViewModel.fetchUserWithId(id: CKRecord.ID(recordName: "AEDA4BC0-1922-4ACB-A80E-31F3087DC1BA")) else {
                            return
                        }
                        print(user)
                        
                    }
                } label: {
                    Text("Fetch User with AEDA4BC0-1922-4ACB-A80E-31F3087DC1BA id")
                }

            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
           
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
