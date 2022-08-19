//
//  Snake.swift
//  SnakeGame
//
//  Created by advanc3d on 24.07.2022.
//

import Foundation

class Snake {
    var body: [PieceOfSnake] = []
    
    //MARK:- game methods
    func setupNewGame() {
        score = 0
        level = 1
        playerName = ""
        newPiece = PieceOfSnake(x: 0, y: 0).createNewPieceOfSnake()
        gameStatus = GameStatus.running
    }
    
    func createSnake() {
        let snakeHead = PieceOfSnake(x: PieceOfSnake.width, y: PieceOfSnake.height)
        snake.addNewPiece(snakeHead)
    }
    
    func eraseBody() {
        self.body.removeAll()
    }
    
    func saveRecord() -> Bool {
        if score > UserDefaults.standard.integer(forKey: CaseUserDefaults.record) {
            UserDefaults.standard.setValue(score, forKey: CaseUserDefaults.record)
            return true
        }
        return false
    }
    
    func savePlayerName(name: String) {
        playerName = name
        UserDefaults.standard.setValue(playerName, forKey: CaseUserDefaults.playerName)
    }
    
    //MARK:- add or pickup new piece methods
    func addNewPiece(_ newPiece: PieceOfSnake) {
        self.body.append(newPiece)
    }
    
    func pickUpNewPiece(_ newPiece: PieceOfSnake) -> Bool {
        if body[0].x == newPiece.x && body[0].y == newPiece.y {
            body.append(newPiece)
            score += 1
            return true
        }
        return false
    }
    
    //MARK:- moving methods
    func saveLastPositions() {
        for index in 0..<snake.body.count {
            snake.body[index].saveLastPosition()
        }
    }
    func moveSnake(_ dX: Int, _ dY: Int) {
        snake.body[0].x += dX
        snake.body[0].y += dY
        
        for index in 1..<snake.body.count {
            snake.body[index].x = snake.body[index - 1].lastX ?? 0
            snake.body[index].y = snake.body[index - 1].lastY ?? 0
        }
    }
    
    //MARK:- checking current direction
    func checkDirection() -> Direction {
        let head = self.body[0]
        if let lastX = head.lastX, let lastY = head.lastY {
            if (head.x - lastX) > 0 { return .right }
            if (head.x - lastX) < 0 { return .left }
            if (head.y - lastY) > 0 { return .down }
        }
        return .up
    }
    //MARK:- lose game conditions
    func touchedBorders() -> Bool {
        let head = self.body[0]
        
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
    
    func tailIsTouched() -> Bool {
        guard body.count > 1 else { return false }
        for index in stride(from: 1, to: body.count, by: 1) {
            if body[0].x == body[index].x && body[0].y == body[index].y {
                return true
            }
        }
        return false
    }
}
