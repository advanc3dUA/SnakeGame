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
    func createSnake() {
        let snakeHead = PieceOfSnake(x: PieceOfSnake.width, y: PieceOfSnake.height)
        self.body.append(snakeHead)
    }
    
    func eraseSnake() {
        self.body.removeAll()
    }
        
    //MARK:- add or pickup new piece methods
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
}
