//
//  MemoryGame.swift
//  Memorize
//
//  Created by Matthew Wu on 6/18/20.
//  Copyright © 2020 Matthew Wu. All rights reserved.
//

import Foundation

struct MemoryGame<cardContent> where cardContent: Equatable {
    private(set) var cards: Array<Card>
    
    private var indexOfMyOneAndOnlyFaceUpCard: Int? {
        get {
            cards.indices.filter { (index) -> Bool in
                cards[index].isFaceUp
            }.only
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = index == newValue
            }
        }
    }
    
    private(set) var points = 0
    
    mutating func choose(card: Card) {
        //print("card chosen: \(card)")
        if let chosenIndex: Int = cards.firstIndex(matching: card), !cards[chosenIndex].isFaceUp, !cards[chosenIndex].isMatched  {
            if let potentialMatchIndex = indexOfMyOneAndOnlyFaceUpCard {
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                    points += 2
                }
                self.cards[chosenIndex].isFaceUp = true
            } else {
                indexOfMyOneAndOnlyFaceUpCard = chosenIndex
            }
        }
        
    }
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> cardContent) {
        cards = Array<Card>()
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content, id: pairIndex * 2))
            cards.append(Card(content: content, id: pairIndex * 2 + 1))
        }
        cards.shuffle()
    }
    
    struct Card: Identifiable {
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
        
        var content: cardContent
        var id: Int
    
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
        (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining / bonusTimeLimit : 0
    }
    
    var hasEarnedBonus: Bool {
        isMatched && bonusTimeRemaining > 0
    }
    
    var isConsumingBonus: Bool {
        isFaceUp && !isMatched && bonusTimeRemaining > 0
    }
    
    private mutating func startUsingBonusTime() {
        if isConsumingBonus, lastFaceUpDate == nil {
            lastFaceUpDate = Date()
        }
    }
    
    private mutating func stopUsingBonusTime() {
        pastFaceUpTime = faceUpTime
        self.lastFaceUpDate = nil
        }
    }
}
