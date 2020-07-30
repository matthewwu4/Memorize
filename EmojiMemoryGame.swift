//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Matthew Wu on 6/18/20.
//  Copyright © 2020 Matthew Wu. All rights reserved.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    @Published private var model: MemoryGame<String> = EmojiMemoryGame.createMemoryGame()
    
    static var themeChoice: Int = 0
    
    private static func createMemoryGame() -> MemoryGame<String> {
        var emojiThemes = [[String]]()
        
        let halloween: Array<String> = ["👻", "🎃", "🕷", "🧚‍♀️", "🧙‍♀️", "🍭"]
        let beach: Array<String> = ["🌊", "⛱", "🩳", "🐬", "🐡", "🏄‍♂️"]
        let sports: Array<String> = ["⚽️", "🏀", "🏈", "🎾", "🏏", "🥊"]
        let food: Array<String> = ["🍕", "🌭", "🍔", "🍟", "🍙", "🌮"]
        let numbers: Array<String> = ["1️⃣", "0️⃣", "2️⃣", "3️⃣", "4️⃣", "5️⃣"]
        let countries: Array<String> = ["🇹🇼", "🇿🇦", "🇺🇸", "🇳🇮", "🇮🇳", "🇩🇪"]
        
        emojiThemes.append(halloween)
        emojiThemes.append(beach)
        emojiThemes.append(sports)
        emojiThemes.append(food)
        emojiThemes.append(numbers)
        emojiThemes.append(countries)
        themeChoice = Int.random(in: 0...5)
        
        return MemoryGame<String>(numberOfPairsOfCards: 6) { pairIndex in
            return emojiThemes[themeChoice][pairIndex]
        }
    }

    
    // MARK: - Access to the Model
    var cards: Array<MemoryGame<String>.Card> {
        return model.cards
    }
    
    var gamePoints: Int {
        return model.points
    }
    
    func choose(card: MemoryGame<String>.Card) {
        model.choose(card: card)
    }
    
    func resetGame() {
        model = EmojiMemoryGame.createMemoryGame()
    }
    
//    static var themeChoice: Int {
//        return Int.random(in: 0...2)
//    }
    
}
