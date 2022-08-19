//
//  Variables.swift
//  SnakeGame
//
//  Created by advanc3d on 19.08.2022.
//

import Foundation

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
