//
//  Snake.swift
//  SnakeGame
//
//  Created by advanc3d on 24.07.2022.
//

import Foundation

//MARK:- Variables
let fieldWidth: Int = 300
let fieldHeight: Int = 400
let timerTimeIntervalConst = 0.3
let moveSnakeDurationConst = 0.4
var score = 0
var level = 1
var playerName = ""
var speedUpBool = true
var classicModeBool = false
var snake = Snake()
var newPiece = PieceOfSnake(x: 0, y: 0).createNewPieceOfSnake()
var gameStatus = GameStatus.running

enum Direction {
    case up, down, left, right
}

enum CaseUserDefaults {
    static let record = "record"
    static let playerName = "playerName"
}

enum GameStatus {
    case running, lost
}

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
