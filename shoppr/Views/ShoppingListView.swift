//
//  ShoppingListView.swift
//  shoppr
//
//  Created by Brandon Wong on 6/11/22.
//

import RealmSwift
import SwiftUI

struct ShoppingListView: View {
    @ObservedRealmObject var shoppingList: ShoppingList
    @Binding var currency: Int
    @State private var name = ""
    @State private var count = ""
    @State private var price = ""
    @State private var unit = 0
    @State private var displayInput = false
    @State private var searchText = ""
    @State private var displayImagePicker = false
    @FocusState private var nameIsFocused: Bool
    @FocusState private var countIsFocused: Bool
    @FocusState private var priceIsFocused: Bool
    
    let currencies = ["$", "€", "£", "$", "¥"]
    let units = ["ct", "lb", "oz", "kg", "g"]
    
    private var sum: Double {
        return shoppingList.items.lazy.compactMap { $0.price * $0.count }.reduce(0, +)
    }
    
    func searchResults() -> [Item] {
        var items = [Item]()
        
        if searchText.isEmpty {
            for item in shoppingList.items {
                items.append(item)
            }
        } else {
            for item in shoppingList.items {
                if (item.wrappedName.localizedCaseInsensitiveContains(searchText)) {
                    items.append(item)
                }
            }
        }
        
        return items
    }
    
    var body: some View {
        ScrollViewReader { value in
            SwiftUI.List {
                ForEach(searchResults()) { item in
                    NavigationLink(destination: ItemView(item: item, currency: $currency, currencies: currencies)) {
                        HStack {
                            Text("\(item.wrappedName)")
                            Spacer()
                            Text("\(currencies[currency])\(item.price * item.count, specifier: "%.2f")")
                        }
                    }
                }
                .onDelete(perform: $shoppingList.items.remove)
                .onMove(perform: $shoppingList.items.move)
                
                if (displayInput) {
                    VStack {
                        HStack {
                            TextField("Name", text: $name).focused($nameIsFocused)
                            Divider()
                            TextField("Unit Price", text: $price).keyboardType(.decimalPad).disableAutocorrection(true).focused($priceIsFocused)
                            Image(systemName: "camera").font(.system(size: 20)).foregroundColor(.blue)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    nameIsFocused = false
                                    countIsFocused = false
                                    priceIsFocused = false
                                    self.displayImagePicker = true
                                }
                        }
                        .padding([.top, .bottom], 3)
                        Divider()
                        HStack {
                            TextField(unit == 0 ? "Count" : "Weight", text: $count).keyboardType(.decimalPad).focused($countIsFocused)
                            Divider()
                            Picker("Unit", selection: $unit) {
                                ForEach(0 ..< units.count) {
                                    Text("\(units[$0])")
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }
                    }
                    .id(1)
                }
            }
            .onChange(of: displayInput) { _ in
                withAnimation {
                    value.scrollTo(1)
                }
            }
        }
        .searchable(text: $searchText.animation())
        .sheet(isPresented: $displayImagePicker) {
            ImageView(price: $price)
        }
        .navigationTitle(shoppingList.wrappedName)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if (displayInput) {
                    Button("Done") {
                        displayInput.toggle()
                        if (!name.isEmpty) {
                            if (price.isEmpty) { price = "1" }
                            if (count.isEmpty) { count = "1" }
                            if let unwrappedPrice = Double(price) {
                                if let unwrappedCount = Double(count) {
                                    let newItem = Item()
                                    newItem.name = name
                                    newItem.count = unwrappedCount
                                    newItem.price = unwrappedPrice
                                    newItem.unit = units[self.unit]
                                    $shoppingList.items.append(newItem)
                                }
                            }
                            
                            name = ""
                            count = ""
                            price = ""
                            unit = 0
                        }
                    }
                } else {
                    EditButton()
                }
            }
        }
        
        HStack {
            Button(action: {
                displayInput.toggle()
            }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Add Item")
                }
            }
            Spacer()
            Text("Total: \(currencies[currency])\(sum, specifier: "%.2f")")
        }
        .padding()
    }
}
