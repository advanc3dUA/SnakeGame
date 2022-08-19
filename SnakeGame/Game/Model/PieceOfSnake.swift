//
//  PieceOfSnake.swift
//  SnakeGame
//
//  Created by advanc3d on 19.08.2022.
//

import Foundation

struct PieceOfSnake {
    var x: Int {
        didSet {
            if (x - oldValue) > 0 { direction = .right }
            if (x - oldValue) < 0 { direction = .left }
        }
    }
    var y: Int {
        didSet {
            if (y - oldValue) > 0 { direction = .down }
            if (y - oldValue) < 0 { direction = .up }
        }
    }
    var lastX: Int?
    var lastY: Int?
    static let width: Int = 20
    static let height: Int = 20
    var direction: Direction?
    
    
    //MARK:- new piece of snake methods
    func getRandomXY() -> (x: Int, y: Int) {
        var randomX = 0, randomY = 0
        repeat {
            repeat {
                randomX = Int.random(in: (PieceOfSnake.width / 10)...fieldWidth / 10 - 4) * 10
            } while randomX % PieceOfSnake.width != 0
            
            repeat {
                randomY = Int.random(in: (PieceOfSnake.height / 10)...fieldHeight / 10 - 4) * 10
            } while randomY % PieceOfSnake.height != 0
            
        } while checkPointIsInSnakeBody(x: randomX, y: randomY)
        
        return (randomX, randomY)
    }
    
    func checkPointIsInSnakeBody(x: Int, y: Int) -> Bool {
        for piece in snake.body {
            if piece.x == x && piece.y == y {
                return true
            }
        }
        return false
    }
    
    func createNewPieceOfSnake() -> PieceOfSnake {
        let randomFieldPoint = getRandomXY()
        return PieceOfSnake(x: randomFieldPoint.x, y: randomFieldPoint.y)
    }
    
    //MARK:- save last position
    mutating func saveLastPosition() {
        self.lastX = self.x
        self.lastY = self.y
    }
}
