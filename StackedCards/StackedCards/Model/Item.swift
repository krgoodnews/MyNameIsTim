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
    func zIndex(for item: Item, currentIndex: Int, scrollDirection: String) -> CGFloat {
        let isDragLeft = scrollDirection.lowercased() == "left"
        if let index = firstIndex(where: { $0.id == item.id }) {
            if currentIndex == index {
                return CGFloat(count * 3)
            }

            if index > currentIndex {
                return CGFloat(count * (isDragLeft ? 2 : 1)) - CGFloat(index)
            }

            return isDragLeft ? CGFloat(index) : CGFloat(index) + CGFloat(count)
        }

        return .zero
    }
}
