//
//  RunTimeError.swift
//  Memo
//
//  Created by Maxim Ivanov on 09.05.2023.
//

import Foundation

struct RunTimeError: Error, CustomStringConvertible {
    
    let description: String
    
    init(_ description: String) {
        self.description = description
    }
}
