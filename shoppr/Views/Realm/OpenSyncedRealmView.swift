//
//  OpenSyncedRealmView.swift
//  label-scanner
//
//  Created by Brandon Wong on 8/1/22.
//

import RealmSwift
import SwiftUI

/// This view opens a synced realm.
struct OpenSyncedRealmView: View {
    // Use AsyncOpen to download the latest changes from
    // your App Services app before opening the realm.
    // Leave the `partitionValue` an empty string to get this
    // value from the environment object passed in above.
    // @AsyncOpen(appId: "running-total-xxxxx", partitionValue: "", timeout: 4000) var asyncOpen
    
    // always show data, offline
    @AutoOpen(appId: realmKey, partitionValue: "", timeout: 4000) var realmOpen
    
    var body: some View {
        switch realmOpen {
        case .connecting:
            ProgressView()
        case .waitingForUser:
            ProgressView("Waiting for user to log in...")
        case .open(let realm):
            HomeView(user: {
                if realm.objects(User.self).count == 0 {
                    do {
                        try realm.write {
                            realm.add(User())
                        }
                    } catch let error {
                        print("Failed to create user: \(error.localizedDescription)")
                    }
                }
                return realm.objects(User.self).first ?? User()
            }())
        case .progress(let progress):
            ProgressView(progress)
        case .error(let error):
            ErrorView(error: error)
        }
    }
}

struct ErrorView: View {
    var error: Error
        
    var body: some View {
        VStack {
            Text("Error opening the realm: \(error.localizedDescription)")
        }
    }
}
