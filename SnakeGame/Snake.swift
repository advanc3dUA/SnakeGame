//
//  Snake.swift
//  SnakeGame
//
//  Created by advanc3d on 24.07.2022.
//

import Foundation

let fieldWidth: Int = 300
let fieldHeight: Int = 500

struct PieceOfSnake {
    var x: Int
    var y: Int
    let width: Int = 10
    let height: Int = 10
    
    //MARK:- new piece of snake methods
    func getRandomXY(_ fieldWidth: Int, _ fieldHeight: Int) -> (x: Int, y: Int) {
        let randomX = Int.random(in: 0...fieldWidth / 10) * 10
        let randomY = Int.random(in: 0...fieldHeight / 10) * 10
        return (randomX, randomY)
    }
    
    func createNewPieceOfSnake() -> PieceOfSnake {
        let randomFieldPoint = getRandomXY(fieldWidth, fieldHeight)
        return PieceOfSnake(x: randomFieldPoint.x, y: randomFieldPoint.y)
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

