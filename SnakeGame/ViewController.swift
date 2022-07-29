//
//  ViewController.swift
//  SnakeGame
//
//  Created by advanc3d on 24.07.2022.
//

import UIKit

class ViewController: UIViewController {

    //MARK:- Variables
    @IBOutlet var moveButtons: [UIButton]!
    
    var fieldImageView = UIImageView()
    
    var snakeView: [UIView] = []
    
    var newPieceView = UIView()
    
    var timer = Timer()
    
    //MARK:- Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createField(fieldWidth, fieldHeight)
        setupNewGame()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupTimerForMoving(nil)
        
    }
    
    //MARK:- move buttons action
    @IBAction func moveRightButton(_ sender: UIButton) {
        print(currentDirection)
        if snake.checkCurrentDirection() == .up || snake.checkCurrentDirection() == .down {
            timer.invalidate()
            setupTimerForMoving(sender)
        }
    }

    @IBAction func moveLeftButton(_ sender: UIButton) {
        print(currentDirection)
        if snake.checkCurrentDirection() == .up || snake.checkCurrentDirection() == .down {
            timer.invalidate()
            setupTimerForMoving(sender)
        }
    }
    @IBAction func moveUpButton(_ sender: UIButton) {
        print(currentDirection)
        if snake.checkCurrentDirection() == .right || snake.checkCurrentDirection() == .left {
            timer.invalidate()
            setupTimerForMoving(sender)
        }
    }
    
    @IBAction func moveDownButton(_ sender: UIButton) {
        print(currentDirection)
        if snake.checkCurrentDirection() == .right || snake.checkCurrentDirection() == .left {
            timer.invalidate()
            setupTimerForMoving(sender)
        }
    }
    
    //MARK:- field methods
    private func createField(_ fieldWidth: Int, _ fieldHeight: Int) {
        fieldImageView = UIImageView(frame: CGRect(x: Int(view.center.x) - fieldWidth / 2,
                                                   y: Int(view.center.y) - 350,
                                                   width: fieldWidth,
                                                   height: fieldHeight))
        fieldImageView.backgroundColor = .lightGray
        view.addSubview(fieldImageView)
    }
    
    //MARK:- game methods
    private func setupNewGame() {
        snake.setupNewGame()
        snakeView.removeAll()
        createSnake()
        createNewPieceOfSnakeView()
        for button in moveButtons {
            button.isHidden = false
        }
    }
    
    private func finishGame() {
        timer.invalidate()
        for button in moveButtons {
            button.isHidden = true
        }
        print("you lost")
    }
    
    //MARK:- snake methods
    private func createSnake() {
        let snakeHead = PieceOfSnake(x: 0, y: 0)

        let snakeHeadView = UIView(frame: CGRect(x: fieldImageView.bounds.minX,
                                                 y: fieldImageView.bounds.minY,
                                                 width: CGFloat(snakeHead.width),
                                                 height: CGFloat(snakeHead.height)))
        snakeHeadView.backgroundColor = .black
        fieldImageView.addSubview(snakeHeadView)
        snakeView.append(snakeHeadView)
        snake.addNewPiece(newPiece: snakeHead)
    }
    
    //MARK:- new piece creating
    private func createNewPieceOfSnakeView() {
        newPiece = newPiece.createNewPieceOfSnake()
        newPieceView.frame = CGRect(x: newPiece.x, y: newPiece.y, width: newPiece.width, height: newPiece.height)
        newPieceView.backgroundColor = .black
        fieldImageView.addSubview(newPieceView)
    }
    
    private func setupTimerForMoving(_ sender: UIButton?) {
        timer = Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true, block: {(Timer) in

            if snake.touchedBorders(fieldWidth, fieldHeight) || snake.tailIsTouched() {
                gameStatus = .lost
            }
            
            if gameStatus == .lost { self.finishGame() }
            
            var dX = 0
            var dY = 0
            
            switch sender?.tag {
                case 0: dX -= 10
                case 1: dX += 10
                case 2: dY -= 10
                case 3: dY += 10
                case nil: dX += 10
                default: return
            }
            
            self.moveSnake(dX, dY)
            
            if snake.pickUpNewPiece(newPiece) {
                self.pickupNewPiece(self.newPieceView)
            }
            
        })
    }
    
    private func pickupNewPiece(_ newPieceView: UIView) {
        UIView.animate(withDuration: 1) {
            newPieceView.backgroundColor = .red
            newPieceView.alpha = 0.1
            self.snakeView.append(UIView(frame: CGRect(x: newPieceView.center.x - CGFloat(newPiece.width / 2),
                                                       y: newPieceView.center.y - CGFloat(newPiece.height / 2),
                                                       width: CGFloat(newPiece.width),
                                                       height: CGFloat(newPiece.height))))
            self.snakeView.last?.backgroundColor = .yellow
            self.fieldImageView.addSubview(self.snakeView.last!)
            
            newPieceView.removeFromSuperview()
            self.createNewPieceOfSnakeView()
        } completion: { (_) in
            newPieceView.alpha = 1.0
        }

    }
    
    private func moveSnake(_ dX: Int, _ dY: Int) {
        UIView.animate(withDuration: 0.2) {
            
            snake.saveLastPositions()
            snake.moveSnake(dX, dY)
            currentDirection = snake.checkCurrentDirection()
            print(currentDirection)

            self.snakeView[0].center.x += CGFloat(dX)
            self.snakeView[0].center.y += CGFloat(dY)
            
            for index in 1..<snake.body.count {
                self.snakeView[index].frame = CGRect(x: snake.body[index - 1].lastX ?? 0,
                                                     y: snake.body[index - 1].lastY ?? 0,
                                                     width: snake.body[index - 1].width,
                                                     height: snake.body[index - 1].height)
            }
        }
    }
    

    
}
