//
//  ItemView.swift
//  shoppr
//
//  Created by Brandon Wong on 7/18/22.
//

import RealmSwift
import SwiftUI

struct ItemView: View {
    @ObservedRealmObject var item: Item
    @Binding var currency: Int
    var currencies: [String]
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Unit Price: \(currencies[currency])\(item.price, specifier: "%.2f")")
                if (item.wrappedUnit == "ct") {
                    Text("\(item.count, specifier: "%.0f") for \(currencies[currency])\(item.price * item.count, specifier: "%.2f") total")
                } else {
                    Text("\(item.count, specifier: "%.2f") \(item.wrappedUnit) for \(currencies[currency])\(item.price * item.count, specifier: "%.2f") in total")
                }
                Spacer()
            }.padding(.horizontal)
            Spacer()
        }
        .navigationTitle(item.wrappedName)
        .navigationBarTitleDisplayMode(.inline)
    }
}
