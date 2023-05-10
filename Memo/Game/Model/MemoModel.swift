//
//  MemoModel.swift
//  Memo
//
//  Created by Maxim Ivanov on 09.05.2023.
//

import Foundation
import Combine

class MemoModel {
    
    private struct Points {
        static let matchPoints = 2
        static let wrongMatchPenalty = 1
    }
    
    @Published private(set) var points = 0
    @Published private(set) var totalFlips = 0
    @Published private(set) var matchedCardsCount = 0
    
    public var cards: [Card] = []
    private(set) var prevFaceUpCardIdx = [Int]()
    private var seenCards = Set<Int>()

    
    init(numberOfCardPairs: Int, emojiTheme: EmojiBundles.EmojiTheme) throws {
        guard emojiTheme.emojis.count == numberOfCardPairs else { throw
            RunTimeError("Number of emojis is not equal number of cards")
        }
        
        let emojis = emojiTheme.emojis
        for index in 0 ..< numberOfCardPairs {
            let card = Card(emoji: emojis[index])
            cards += [card, card]
        }
        
        cards.shuffle()
    }
    
    func choseCard(at index: Int) {
        cards[index].state = .faceUp
        if prevFaceUpCardIdx.count == 1 {
            checkMatch(at: index)
        } else {
            prevFaceUpCardIdx.append(index)
        }
    }
    
    private func checkMatch(at index: Int) {
        guard index != prevFaceUpCardIdx.first! else { return }
        totalFlips += 1
        let prevFaceUpCard = cards[prevFaceUpCardIdx.first!]
        let currentCard = cards[index]
        if currentCard.id == prevFaceUpCard.id {
            cards[index].state = .matched
            cards[prevFaceUpCardIdx.first!].state = .matched
            prevFaceUpCardIdx = []
            points += Points.matchPoints
            matchedCardsCount += 1
            
        } else {
            if seenCards.contains(index) {
                points -= Points.wrongMatchPenalty
            }
            
            if seenCards.contains(prevFaceUpCardIdx.first!) {
                points -= Points.wrongMatchPenalty
            }
            
            cards[index].state = .notMatched
            cards[prevFaceUpCardIdx.first!].state = .notMatched
            seenCards.formUnion([index, prevFaceUpCardIdx.first!])
            prevFaceUpCardIdx = []
        }
    }
    
    func resetGame() {
        totalFlips = 0
        points = 0
        seenCards = []
        
        for index in cards.indices {
            cards[index].state = .faceDown
        }
        
        cards.shuffle()
    }
}
