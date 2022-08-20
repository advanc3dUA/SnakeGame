//
//  Game.swift
//  SnakeGame
//
//  Created by advanc3d on 20.08.2022.
//

import Foundation

class Game {
    static var status: GameStatus = .lost {
        didSet {
            if oldValue == .lost {
                print("status changed to started")
                postLostGameNotification()
            } else {
                print("status changed to lost")
                //TODO:- add lost notification
            }
        }
    }
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
    
    //MARK:- lose game conditions
    static func touchedBorders() -> Bool {
        let head = snake.body[0]
        
        if head.x < 20 && snake.body[0].direction == .left {
            return true
        }
        if head.x > fieldWidth - 2 * PieceOfSnake.width && snake.body[0].direction == .right {
            return true
        }
        if head.y < 20 && snake.body[0].direction == .up {
            return true
        }
        if head.y > fieldHeight - 2 * PieceOfSnake.height && snake.body[0].direction == .down {
            return true
        }
        return false
    }
    
    static func tailIsTouched() -> Bool {
        guard snake.body.count > 1 else { return false }
        for index in stride(from: 1, to: snake.body.count, by: 1) {
            if snake.body[0].x == snake.body[index].x && snake.body[0].y == snake.body[index].y {
                return true
            }
        }
        return false
    }
    
    static private func postLostGameNotification() {
        NotificationCenter.default.post(name: .lostGame, object: nil)
    }
    
}

extension NSNotification.Name {
    static var lostGame: Notification.Name {
        return .init("lostGame")
    }
}
