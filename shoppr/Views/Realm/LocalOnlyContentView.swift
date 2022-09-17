//
//  LocalOnlyContentView.swift
//  shoppr
//
//  Created by Brandon Wong on 8/2/22.
//

import RealmSwift
import SwiftUI

/// The main content view if not using Sync.
struct LocalOnlyContentView: View {
    // Implicitly use the default realm's objects(ShoppingLists.self)
    @ObservedResults(User.self) var users
    
    var body: some View {
        if let user = users.first {
            // Pass the ItemGroup objects to a view further
            // down the hierarchy
            HomeView(user: user)
        } else {
            // For this small app, we only want one user in the realm.
            // If there is no user, add one here.
            ProgressView().onAppear {
                $users.append(User())
            }
        }
    }
}
