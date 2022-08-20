//
//  Record.swift
//  SnakeGame
//
//  Created by advanc3d on 20.08.2022.
//

import Foundation

class Record {
    static func saveRecord() -> Bool {
        if score > UserDefaults.standard.integer(forKey: CaseUserDefaults.record) {
            UserDefaults.standard.setValue(score, forKey: CaseUserDefaults.record)
            return true
        }
        return false
    }
    
    static func savePlayerName(name: String) {
        playerName = name
        UserDefaults.standard.setValue(playerName, forKey: CaseUserDefaults.playerName)
    }
}
