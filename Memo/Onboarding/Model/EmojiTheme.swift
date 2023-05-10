//
//  EmojiBundle.swift
//  Memo
//
//  Created by Maxim Ivanov on 09.05.2023.
//

import Foundation

enum EmojiBundles: String {
    
    struct EmojiTheme {
        public let name: String
        public let emojis: [String]
    }
    
    case transport = "Transport"
    case countries = "Countries"
    case animals = "Animals"
    case food = "Food"
    
}

extension EmojiBundles {
    public var theme: EmojiTheme {
        switch self {
        case .transport:
            return EmojiTheme(name: self.rawValue,
                              emojis: [
                                "🚗", "🚕", "🚲", "🚆", "🚀", "🚁", "🚢", "🛵", "🚚", "🛴"
                              ])
        case .animals:
            return EmojiTheme(name: self.rawValue,
                              emojis: [
                                "🐶", "🐱", "🐰", "🐼", "🐻", "🦁", "🦊", "🦜", "🐠", "🦀"
                              ])
        case .food:
            return EmojiTheme(name: self.rawValue,
                              emojis: [
                                "🍔", "🍟", "🍕", "🍦", "🌮", "🍣", "🥐", "🍩", "🥞", "🥪"
                              ])
        case .countries:
            return EmojiTheme(name: self.rawValue,
                              emojis: [
                                "🇺🇸", "🇬🇧", "🇫🇷", "🇮🇹", "🇯🇵", "🇧🇷", "🇲🇽", "🇪🇸", "🇨🇳", "🇮🇳"
                              ])
        }
    }
}

