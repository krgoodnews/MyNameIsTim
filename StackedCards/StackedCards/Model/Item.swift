//
//  Item.swift
//  StackedCards
//
//  Created by Tim Guk on 12/28/24.
//

import SwiftUI

struct Item: Identifiable {
    var id = UUID()
    var color: Color
}

let items: [Item] = [
    Item(color: .red),
    Item(color: .blue),
    Item(color: .green),
    Item(color: .orange),
    Item(color: .purple),
    Item(color: .yellow),
]

extension [Item] {
    func zIndex(for item: Item) -> CGFloat {
        if let index = firstIndex(where: { $0.id == item.id }) {
            return CGFloat(count) - CGFloat(index)
        }

        return .zero
    }
}
