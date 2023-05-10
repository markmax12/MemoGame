//
//  HighScore.swift
//  Memo
//
//  Created by Maxim Ivanov on 10.05.2023.
//

import Foundation

final class ScoresSingleton: Codable {
    
    static let newScoreSet = Notification.Name("NewScoreSet")
    static private let documentDirectory = try! FileManager.default.url(for: .libraryDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    static let shared = ScoresSingleton(url: documentDirectory)
    
    public var highScore = 0
    public var lastScore = 0
    
    private init(url: URL?) {
        if let url,
           let data = try? Data(contentsOf: url.appending(path: String.storeLocation)),
           let instance = try? JSONDecoder().decode(ScoresSingleton.self, from: data) {
            self.highScore = instance.highScore
            self.lastScore = instance.lastScore
        } else {
            self.highScore = 0
            self.lastScore = 0
        }
    }
    
    func save(_ notifying: ScoresSingleton, userInfo: [AnyHashable: Any]) {
        if let savedData = try? JSONEncoder().encode(self) {
            try! savedData.write(to: Self.documentDirectory.appendingPathComponent(.storeLocation))
        }
        NotificationCenter.default.post(name: ScoresSingleton.newScoreSet, object: notifying, userInfo: userInfo)
    }
}

extension ScoresSingleton {
    static let notificationReason = "notificationReason"
    static let newLastScore = "newLastScore"
    static let newHighScore = "newHighScore"
}

fileprivate extension String {
    static let storeLocation = "store.json"
}
