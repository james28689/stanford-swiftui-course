//
//  stanford_courseApp.swift
//  stanford-course
//
//  Created by James Watling on 10/01/2021.
//

import SwiftUI

let game = EmojiMemoryGame()

@main
struct stanford_courseApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: game)
        }
    }
}
