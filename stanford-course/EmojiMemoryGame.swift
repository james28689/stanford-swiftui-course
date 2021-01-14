//
//  EmojiMemoryGame.swift
//  stanford-course
//
//  Created by James Watling on 10/01/2021.
//

import Foundation

class EmojiMemoryGame: ObservableObject {
    @Published private var model: MemoryGame<String> = EmojiMemoryGame.createMemoryGame(theme: EmojiMemoryGame.themes[0])
    
    static func createMemoryGame(theme: MemoryGame<String>.Theme) -> MemoryGame<String> {
        var memoryGame = MemoryGame<String>(numberOfPairsOfCards: Int.random(in: 2...5), theme: theme)
        memoryGame.cards.shuffle()
        return memoryGame
    }
    
    static let themes: [MemoryGame<String>.Theme] = [
        MemoryGame.Theme(name: "Halloween", contents: ["👻", "🎃", "🕷", "🕸", "🧙‍♀️"], accentColor: .orange),
        MemoryGame.Theme(name: "Smileys", contents: ["😃", "😅", "😂", "😇", "😍"], accentColor: .yellow),
        MemoryGame.Theme(name: "Christmas", contents: ["🎅", "🎄", "🎁", "🧑‍🎄", "⛄️"], accentColor: .red)
    ]
    
    //MARK: - Access to the Model
    
    var cards: Array<MemoryGame<String>.Card> {
        model.cards
    }
    
    var score: Int {
        model.score
    }
    
    var theme: MemoryGame<String>.Theme {
        model.theme
    }
    
    //MARK: - Intents
    
    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
    }
    
    func changeTheme(_ theme: MemoryGame<String>.Theme) {
        model.theme = theme
    }
}
