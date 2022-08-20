//
//  Game.swift
//  SnakeGame
//
//  Created by advanc3d on 20.08.2022.
//

import Foundation

class Game {
    static var status: GameStatus = .lost
    static var shared = Game()
    
    private init() { }
    
    static func setupNewGame() {
        score = 0
        level = 1
        playerName = ""
        newPiece = PieceOfSnake(x: 0, y: 0).createNewPieceOfSnake()
        Game.status = .started
    }
    
    static func finishGame() {
        
    }
}
