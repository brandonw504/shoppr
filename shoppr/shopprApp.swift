//
//  shopprApp.swift
//  shoppr
//
//  Created by Brandon Wong on 6/9/22.
//

import RealmSwift
import SwiftUI

let app: RealmSwift.App? = RealmSwift.App(id: realmKey) // TODO: key in

@main
struct shopprApp: SwiftUI.App {
    var body: some Scene {
        WindowGroup {
            // Using Sync?
            if let app = app {
                SyncContentView(app: app)
            } else {
                LocalOnlyContentView()
            }
        }
    }
}
