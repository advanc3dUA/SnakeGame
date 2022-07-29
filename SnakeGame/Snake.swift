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
    case upOrDown, leftOrRight
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
        print("got field w & h: ", fieldWidth, fieldHeight)
        let randomX = Int.random(in: 0...fieldWidth / 10 - 1) * 10
        let randomY = Int.random(in: 0...fieldHeight / 10 - 1) * 10
        return (randomX, randomY)
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
        if abs(head.x - head.lastX!) > 0 {
            return .upOrDown
        } else {
            return .leftOrRight
        }
        
    }
    //MARK:- lose game conditions
    func isOutOfBorders(widthOfBoard: Int, heightOfBoard: Int) -> Bool {
        let head = self.body[0]
        
        if head.x < widthOfBoard || head.x > widthOfBoard {
            return true
        }
        
        if head.y < heightOfBoard || head.y > heightOfBoard {
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
var allowedDirection = CurrentDirection.upOrDown
