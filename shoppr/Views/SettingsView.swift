//
//  ProfileView.swift
//  shoppr
//
//  Created by Brandon Wong on 7/12/22.
//

import SwiftUI
import RealmSwift

struct SettingsView: View {
    @ObservedRealmObject var user: User
    
    let currencies = ["USD", "EUR", "GBP", "CAD", "JPY"]
    @Binding var currency: Int
    
    var body: some View {
        NavigationView {
            List {
                Picker("Currency", selection: $currency) {
                    ForEach(0 ..< currencies.count) {
                        Text("\(currencies[$0])")
                    }
                }
                Section {
                    LogoutButton(user: user)
                }
            }
            .navigationTitle("Settings")
        }
    }
}

struct LogoutButton: View {
    let realm = try! Realm()
    @ObservedRealmObject var user: User
    
    @State var isLoggingOut = false
    @State var showingAlert = false
    @State var anonymous = false
    var logOut = false
    
    var body: some View {
        Button(action: {
            guard let user = app!.currentUser else {
                return
            }
            if (user.identities.first!.providerType == "anon-user") {
                anonymous = true
            } else {
                anonymous = false
            }
            showingAlert = true
        }) {
            Text("Log Out").foregroundColor(Color.red)
        }
        .disabled(app!.currentUser == nil || isLoggingOut)
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Log Out"), message: anonymous ? Text("You aren't logged in with an account. Are you sure you want to log out? You will lose your data.") : Text("Are you sure you want to log out?"), primaryButton: .destructive(Text("Log Out")) {
                isLoggingOut = true
//                if anonymous {
//                    if let userToDelete = realm.objects(User.self).filter("_id == %@", user._id).first {
//                        try! realm.write {
//                            realm.delete(userToDelete)
//                        }
//                    }
//                }
                AuthenticationManager.logout()
                isLoggingOut = false
            }, secondaryButton: .cancel())
        }
    }
}
