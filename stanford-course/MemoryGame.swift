//
//  MemoryGame.swift
//  stanford-course
//
//  Created by James Watling on 10/01/2021.
//

import Foundation
import SwiftUI

struct MemoryGame<CardContent> where CardContent: Equatable {
    
    // MARK: - Stored Values
    
    private(set) var cards: Array<Card>
    
    var score: Int = 0
    
    private(set) var theme: Theme {
        willSet {
            for index in 0..<(cards.count / 2) {
                for card in cards.filter({ $0.contentIndex == index }) {
                    cards[cards.firstIndex(matching: card)!].content = newValue.contents[index]
                }
            }
        }
    }
    
    private var onlyFaceUpCardIndex: Int? {
        get { cards.indices.filter({ cards[$0].isFaceUp }).only }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = index == newValue
            }
        }
    }
    
    // MARK: - Editing / Encapsulation functions
    
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
    
    mutating func changeTheme(to theme: Theme) {
        self.theme = theme
    }
    
    // MARK: - Initialiser
    
    init(numberOfPairsOfCards: Int, theme: Theme) {
        cards = Array<Card>()
        self.theme = theme
        
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = theme.contents[pairIndex]
            cards.append(Card(id: (pairIndex * 2) - 1, contentIndex: pairIndex, content: content))
            cards.append(Card(id: pairIndex * 2, contentIndex: pairIndex, content: content))
        }
        
        cards.shuffle()
    }
    
    // MARK: - Child Structs
    
    struct Card: Identifiable {
        var id: Int
        
        var isFaceUp: Bool = false {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
            }
        }
        
        var isMatched: Bool = false {
            didSet {
                stopUsingBonusTime()
            }
        }
        
        var contentIndex: Int
        var content: CardContent
        
        var bonusTimeLimit: TimeInterval = 6
        
        private var faceUpTime: TimeInterval {
            if let lastFaceUpDate = self.lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        
        var lastFaceUpDate: Date?
        
        var pastFaceUpTime: TimeInterval = 0
        
        var bonusTimeRemaining: TimeInterval {
            max(0, bonusTimeLimit - faceUpTime)
        }
        
        var bonusRemaining: Double {
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining/bonusTimeLimit : 0
        }
        
        var hasEarnedBonus: Bool {
            isMatched && bonusTimeRemaining > 0
        }
        
        var isConsumingBonusTime: Bool {
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }
        
        private mutating func startUsingBonusTime() {
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            self.lastFaceUpDate = nil
        }
    }
    
    struct Theme {
        var name: String
        var contents: [CardContent]
        var accentColor: Color
    }
    
    
}
