//
//  MemoryGame.swift
//  stanford-course
//
//  Created by James Watling on 10/01/2021.
//

import Foundation
import SwiftUI

struct MemoryGame<CardContent> where CardContent: Equatable {
    var cards: Array<Card>
    var score: Int = 0
    var theme: Theme {
        willSet {
            for index in 0..<(cards.count / 2) {
                for card in cards.filter({ $0.contentIndex == index }) {
                    cards[cards.firstIndex(matching: card)!].content = newValue.contents[index]
                }
            }
        }
    }
    
    var onlyFaceUpCardIndex: Int? {
        get { cards.indices.filter({ cards[$0].isFaceUp }).only }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = index == newValue
            }
        }
    }
    
    mutating func choose(_ card: Card) {
        print("Card chosen: \(card)")
        if let chosenIndex: Int = cards.firstIndex(matching: card), !cards[chosenIndex].isFaceUp, !cards[chosenIndex].isMatched {
            if let potentialMatchIndex = onlyFaceUpCardIndex {
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                    score += 2
                } else {
                    score -= 1
                }
                cards[chosenIndex].isFaceUp = true
            } else {
                onlyFaceUpCardIndex = chosenIndex
            }
        }
    }
    
    init(numberOfPairsOfCards: Int, theme: Theme) {
        cards = Array<Card>()
        self.theme = theme
        
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = theme.contents[pairIndex]
            cards.append(Card(contentIndex: pairIndex, content: content))
            cards.append(Card(contentIndex: pairIndex, content: content))
        }
    }
    
    struct Card: Identifiable {
        let id = UUID()
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var contentIndex: Int
        var content: CardContent
    }
    
    struct Theme {
        var name: String
        var contents: [CardContent]
        var accentColor: Color
    }
}
