//
//  AddItemView.swift
//  label-scanner
//
//  Created by Brandon Wong on 6/10/22.
//

import RealmSwift
import SwiftUI
import CoreLocation
import MapKit

struct AddShoppingListView: View {
    @ObservedRealmObject var user: User
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var localSearchViewData = LocalSearchViewData()
    @StateObject var locationManager = LocationManager()
    
    @State private var showingSearchResults = true
    @State private var name = ""
    @State private var date = Date()
    @State private var address = ""
    @State private var findingLocation = false
    @State private var showingAlert = false
    @FocusState private var locationIsFocused: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                Divider()
                TextField("Name", text: $name)
                Divider()
                DatePicker("Date", selection: $date, displayedComponents: [.date])
                Divider()
                VStack {
                    HStack {
                        TextField("Store", text: $localSearchViewData.locationText).focused($locationIsFocused).onTapGesture {
                            showingSearchResults = true
                            locationManager.requestLocation()
                            if let loc = locationManager.location {
                                localSearchViewData.currentLocation = loc
                            }
                        }
                        
                        Button(action: {
                            localSearchViewData.locationText = ""
                        }) {
                            Image(systemName: "multiply.circle.fill").foregroundColor(.gray).font(.system(size: 20))
                        }
                    }.padding([.top, .bottom], 3)
                    
                    Divider()
                    
                    if (showingSearchResults) {
                        SwiftUI.List(localSearchViewData.viewData) { place in
                            VStack(alignment: .leading) {
                                Text(place.title)
                                Text(place.subtitle).foregroundColor(.secondary)
                            }.onTapGesture {
                                localSearchViewData.locationText = place.title
                                address = place.subtitle
                                showingSearchResults = false
                                locationIsFocused = false
                            }
                        }
                    } else {
                        Spacer()
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top)
            .ignoresSafeArea(edges: .bottom)
            .navigationTitle("Add Shopping List")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }, trailing:
                Button("Save") {
                    if localSearchViewData.locationText.isEmpty {
                        showingAlert = true
                    } else {
                        let newList = ShoppingList()
                        newList.name = name
                        newList.location = localSearchViewData.locationText
                        newList.address = address
                        newList.date = date
                        $user.shoppingLists.append(newList)
                        
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            )
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Error"), message: Text("You need to fill out the location field."), dismissButton: .default(Text("OK")))
            }
        }
    }
}
