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

extension [Item] {
    func zIndex(for item: Item, currentIndex: Int) -> CGFloat {
        if let index = firstIndex(where: { $0.id == item.id }) {
            if currentIndex == index {
                return CGFloat(count * 3)
            }

            if index > currentIndex {
                return CGFloat(count * 2) - CGFloat(index)
            }

            return CGFloat(index)

//            let originIndex = CGFloat(count) - CGFloat(index)
//            if index < currentIndex {
//                return originIndex
//            }
//            return 50 - originIndex
        }

        return .zero
    }
}
