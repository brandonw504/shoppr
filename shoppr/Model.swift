//
//  Model.swift
//  shoppr
//
//  Created by Brandon Wong on 8/2/22.
//

import Foundation
import RealmSwift

final class User: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var shoppingLists = RealmSwift.List<ShoppingList>()
}

final class ShoppingList: EmbeddedObject, ObjectKeyIdentifiable {
    @Persisted var _id: ObjectId
    @Persisted var name: String?
    @Persisted var location: String?
    @Persisted var address: String?
    @Persisted var date: Date?
    @Persisted var items = RealmSwift.List<Item>()
    
    var wrappedName: String {
        name ?? "Unknown Name"
    }
    
    var wrappedLocation: String {
        location ?? "Unknown Location"
    }
    
    var wrappedAddress: String {
        address ?? "Unknown Address"
    }
    
    var wrappedDate: Date {
        date ?? Date()
    }
}

final class Item: EmbeddedObject, ObjectKeyIdentifiable {
    @Persisted var id: ObjectId
    @Persisted var name: String?
    @Persisted var count: Double
    @Persisted var price: Double
    @Persisted var unit: String?
    
    var wrappedName: String {
        name ?? "Unknown Name"
    }
    
    var wrappedUnit: String {
        unit ?? "Unknown Unit"
    }
}
