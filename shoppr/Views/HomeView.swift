//
//  ContentView.swift
//  label-scanner
//
//  Created by Brandon Wong on 6/9/22.
//

import RealmSwift
import SwiftUI

struct HomeView: View {
    @ObservedRealmObject var user: User
    @AppStorage("currency") private var currency = 0
    
    var body: some View {
        TabView {
            ShoppingListsView(user: user, currency: $currency)
                .tabItem {
                    Image(systemName: "cart").font(.system(size: 25))
                }
            
            SettingsView(user: user, currency: $currency)
                .tabItem {
                    Image(systemName: "gearshape").font(.system(size: 25))
                }
        }
    }
}
