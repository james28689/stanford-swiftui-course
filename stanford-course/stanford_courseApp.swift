//
//  stanford_courseApp.swift
//  stanford-course
//
//  Created by James Watling on 10/01/2021.
//

import SwiftUI

@main
struct stanford_courseApp: App {
    @StateObject var game = EmojiMemoryGame()
    
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(viewModel: game)
        }
    }
}
