//
//  Snake.swift
//  SnakeGame
//
//  Created by advanc3d on 24.07.2022.
//

import Foundation

let fieldWidth: Int = 300
let fieldHeight: Int = 500

enum CurrentDirection {
    case up, down, left, right
}

enum GameStatus {
    case running, lost
}

struct PieceOfSnake {
    var x: Int
    var y: Int
    var lastX: Int?
    var lastY: Int?
    let width: Int = 10
    let height: Int = 10
    
    
    //MARK:- new piece of snake methods
    func getRandomXY(_ fieldWidth: Int, _ fieldHeight: Int) -> (x: Int, y: Int) {
        var randomX = 0, randomY = 0
        repeat {
            randomX = Int.random(in: self.width...fieldWidth / 10 - 2) * 10
            randomY = Int.random(in: self.height...fieldHeight / 10 - 2) * 10
        } while checkPointIsInSnakeBody(snakeBody: snake.body, x: randomX, y: randomY)
        
        return (randomX, randomY)
    }
    
    func checkPointIsInSnakeBody(snakeBody: [PieceOfSnake], x: Int, y: Int) -> Bool {
        for piece in snakeBody {
            if piece.x == x && piece.y == y {
                return true
            }
        }
        return false
    }
    
    func createNewPieceOfSnake() -> PieceOfSnake {
        let randomFieldPoint = getRandomXY(fieldWidth, fieldHeight)
        return PieceOfSnake(x: randomFieldPoint.x, y: randomFieldPoint.y)
    }
    
    //MARK:- save last position
    mutating func saveLastPosition() {
        self.lastX = self.x
        self.lastY = self.y
    }
}

class Snake {
    var body: [PieceOfSnake] = []
    
    //MARK:- setup new game
    func setupNewGame() {
        newPiece = PieceOfSnake(x: 0, y: 0).createNewPieceOfSnake()
        currentDirection = CurrentDirection.right
        gameStatus = GameStatus.running
    }
    
    func createSnake() {
        let snakeHead = PieceOfSnake(x: newPiece.width, y: newPiece.height)
        snake.addNewPiece(newPiece: snakeHead)
    }
    
    func eraseBody() {
        self.body.removeAll()
    }
    
    //MARK:- add or pickup new piece methods
    func addNewPiece(newPiece: PieceOfSnake) {
        self.body.append(newPiece)
    }
    
    func pickUpNewPiece(_ newPiece: PieceOfSnake) -> Bool {
        if body[0].x == newPiece.x && body[0].y == newPiece.y {
            body.append(newPiece)
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
    func checkCurrentDirection() -> CurrentDirection {
        let head = self.body[0]
        if let lastX = head.lastX, let lastY = head.lastY {
            if (head.x - lastX) > 0 { return .right }
            if (head.x - lastX) < 0 { return .left }
            if (head.y - lastY) > 0 { return .down }
        }
        return .up
    }
    //MARK:- lose game conditions
    func touchedBorders(_ widthOfBoard: Int, _ heightOfBoard: Int) -> Bool {
        let head = self.body[0]
        
        if head.x < 10 && currentDirection == .left {
            return true
        }
        if head.x > fieldWidth - 2 * newPiece.width && currentDirection == .right {
            return true
        }
        if head.y < 10 && currentDirection == .up {
            return true
        }
        if head.y > fieldHeight - 2 * newPiece.height && currentDirection == .down {
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


var snake = Snake()
var newPiece = PieceOfSnake(x: 0, y: 0).createNewPieceOfSnake()
var currentDirection = CurrentDirection.right
var gameStatus = GameStatus.running
