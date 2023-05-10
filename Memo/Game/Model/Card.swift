//
//  Card.swift
//  Memo
//
//  Created by Maxim Ivanov on 09.05.2023.
//

import Foundation

enum CardState {
    case faceUp, faceDown, matched, notMatched
}

struct Card {
    
    var state: CardState = .faceDown
    var id: Int
    var emoji: String

    private static var _id = 0
    
    private static func makeID() -> Int {
        _id += 1
        return _id
    }
    
    init(emoji: String) {
        self.id = Self.makeID()
        self.emoji = emoji
    }
}
