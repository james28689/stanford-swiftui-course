//
//  Grid.swift
//  stanford-course
//
//  Created by James Watling on 12/01/2021.
//

import SwiftUI

struct Grid<Item, ItemView>: View where Item: Identifiable, ItemView: View {
    private var items: [Item]
    private var viewForItem: (Item) -> ItemView
    
    init(_ items: [Item], viewForItem: @escaping (Item) -> ItemView) {
        self.items = items
        self.viewForItem = viewForItem
    }
    
    var body: some View {
        GeometryReader { geometry in
            ForEach(items) { item in
                try? innerView(for: item, in: GridLayout(itemCount: items.count, in: geometry.size))
            }
        }
    }
    
    private func innerView(for item: Item, in layout: GridLayout) throws -> some View {
        let index = items.firstIndex(matching: item)
        return Group {
            if let index = index {
                viewForItem(item)
                    .frame(width: layout.itemSize.width, height: layout.itemSize.height)
                    .position(layout.location(ofItemAt: index))
            }
        }
    }
}
