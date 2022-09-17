//
//  EditShoppingListView.swift
//  shoppr
//
//  Created by Brandon Wong on 7/19/22.
//

import SwiftUI

struct EditShoppingListView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var localSearchViewData = LocalSearchViewData()
    @StateObject var locationManager = LocationManager()
    
    @State private var showingSearchResults = false
    @State private var showingAlert = false
    @Binding var name: String
    @Binding var location: String
    @Binding var address: String
    @FocusState private var locationIsFocused: Bool
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Divider()
                TextField("Name", text: $name)
                Divider()
                HStack {
                    TextField("Store", text: $localSearchViewData.locationText).focused($locationIsFocused).onTapGesture {
                        showingSearchResults = true
                        locationManager.requestLocation()
                        if let loc = locationManager.location {
                            localSearchViewData.currentLocation = loc
                        }
                    }.onAppear {
                        localSearchViewData.locationText = location
                    }
                    
                    Button(action: {
                        localSearchViewData.locationText = ""
                    }) {
                        Image(systemName: "multiply.circle.fill").foregroundColor(.gray).font(.system(size: 20))
                    }
                }.padding([.top, .bottom], 3)
                
                Divider()
                
                if (showingSearchResults) {
                    List(localSearchViewData.viewData) { place in
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
            .padding(.horizontal)
            .navigationTitle("Edit Shopping List")
            .navigationBarItems(trailing:
                Button("Save") {
                    if localSearchViewData.locationText.isEmpty {
                        showingAlert = true
                    } else {
                        location = localSearchViewData.locationText
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
