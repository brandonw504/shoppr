//
//  ShoppingListsView.swift
//  label-scanner
//
//  Created by Brandon Wong on 7/12/22.
//

import RealmSwift
import SwiftUI

enum ActiveSheet: Identifiable {
    case showingAddItem, showingEditItem
    
    var id: Int {
        hashValue
    }
}

struct ShoppingListsView: View {
    @ObservedRealmObject var user: User
    @State var isEditMode: EditMode = .inactive
    @Binding var currency: Int
    @State private var activeSheet: ActiveSheet?
    @State private var searchText = ""
    @State private var name = ""
    @State private var location = ""
    @State private var address = ""
    @State private var currentName = ""
    @State private var currentLocation = ""
    @State private var currentAddress = ""
    
    func searchResults() -> [ShoppingList] {
        var shoppingLists = [ShoppingList]()
        
        if searchText.isEmpty {
            for shoppingList in self.user.shoppingLists {
                shoppingLists.append(shoppingList)
            }
        } else {
            for shoppingList in self.user.shoppingLists {
                if (shoppingList.wrappedName.localizedCaseInsensitiveContains(searchText) || shoppingList.wrappedLocation.localizedCaseInsensitiveContains(searchText)) {
                    shoppingLists.append(shoppingList)
                }
            }
        }
        
        return shoppingLists
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(searchResults()) { shoppingList in
                    NavigationLink(destination: ShoppingListView(shoppingList: shoppingList, currency: $currency)) {
                        VStack(alignment: .leading) {
                            Text(shoppingList.wrappedName)
                                .font(.headline)
                            Text(shoppingList.wrappedLocation)
                        }
                    }
                    .contentShape(Rectangle())
                    .gesture(isEditMode == .active ? TapGesture().onEnded {
                        currentName = shoppingList.wrappedName
                        currentLocation = shoppingList.wrappedLocation
                        currentAddress = shoppingList.wrappedAddress
                        activeSheet = .showingEditItem
                    } : nil)
                    .onChange(of: currentName) { newValue in
                        shoppingList.name = newValue
                    }
                    .onChange(of: currentLocation) { newValue in
                        shoppingList.location = newValue
                    }
                    .onChange(of: currentAddress) { newValue in
                        shoppingList.address = newValue
                    }
                }
                .onDelete(perform: $user.shoppingLists.remove)
                .onMove(perform: $user.shoppingLists.move)
            }
            .searchable(text: $searchText.animation())
            .disableAutocorrection(true)
            .navigationTitle("Lists")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        activeSheet = .showingAddItem
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(item: $activeSheet) { item in
                switch item {
                case .showingAddItem:
                    AddShoppingListView(user: user)
                case .showingEditItem:
                    EditShoppingListView(name: $currentName, location: $currentLocation, address: $currentAddress)
                }
            }
            .environment(\.editMode, self.$isEditMode)
        }
    }
}
