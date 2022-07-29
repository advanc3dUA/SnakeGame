//
//  ViewController.swift
//  SnakeGame
//
//  Created by advanc3d on 24.07.2022.
//

import UIKit

class ViewController: UIViewController {

    //MARK:- Variables
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
        createSnake()
        createNewPieceOfSnake()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupTimerForMoving(nil)
        
    }
    
    //MARK:- move buttons action
    @IBAction func moveRightButton(_ sender: UIButton) {
        timer.invalidate()
        setupTimerForMoving(sender)
    }

    @IBAction func moveLeftButton(_ sender: UIButton) {
        timer.invalidate()
        setupTimerForMoving(sender)
    }
    
    @IBAction func moveUpButton(_ sender: UIButton) {
        timer.invalidate()
        setupTimerForMoving(sender)
    }
    
    @IBAction func moveDownButton(_ sender: UIButton) {
        timer.invalidate()
        setupTimerForMoving(sender)
    }
    
    //MARK:- field methods
    private func createField(_ fieldWidth: Int, _ fieldHeight: Int) {
        fieldImageView = UIImageView(frame: CGRect(x: Int(view.center.x) - fieldWidth / 2,
                                                   y: Int(view.center.y) - fieldHeight / 2,
                                                   width: fieldWidth,
                                                   height: fieldHeight))
        fieldImageView.backgroundColor = .lightGray
        view.addSubview(fieldImageView)
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
    private func createNewPieceOfSnake() {
        newPiece = newPiece.createNewPieceOfSnake()
        newPieceView.frame = CGRect(x: newPiece.x, y: newPiece.y, width: newPiece.width, height: newPiece.height)
        newPieceView.backgroundColor = .black
        fieldImageView.addSubview(newPieceView)
    }
    //MARK: похоже надо возвращать текующее направление движения, а потом в кнопках проверять доступность поворота
    private func setupTimerForMoving(_ sender: UIButton?) {
        timer = Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true, block: {(Timer) in
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
                print(snake.body.count, self.snakeView.count)
            }
            
        })
    }
    
    private func pickupNewPiece(_ newPieceView: UIView) {
        UIView.animate(withDuration: 1) {
            newPieceView.backgroundColor = .red
            newPieceView.alpha = 0.0
            self.snakeView.append(UIView(frame: CGRect(x: newPieceView.center.x - CGFloat(newPiece.width / 2),
                                                       y: newPieceView.center.y - CGFloat(newPiece.height / 2),
                                                       width: CGFloat(newPiece.width),
                                                       height: CGFloat(newPiece.height))))
            self.snakeView.last?.backgroundColor = .yellow
    
            
            self.fieldImageView.addSubview(self.snakeView.last!)
        } completion: { (_) in
            newPieceView.removeFromSuperview()
            self.createNewPieceOfSnake()
            newPieceView.alpha = 1.0
        }

    }
    
    private func moveSnake(_ dX: Int, _ dY: Int) {
        UIView.animate(withDuration: 0.15) {
            
            for index in 0..<snake.body.count {
                snake.body[index].saveLastPosition()
            }
            snake.body[0].x += dX
            snake.body[0].y += dY
            
            for index in 1..<snake.body.count {
                snake.body[index].x = snake.body[index - 1].lastX!
                snake.body[index].y = snake.body[index - 1].lastY!
                self.snakeView[index].frame = CGRect(x: snake.body[index - 1].lastX!, y: snake.body[index - 1].lastY!, width: 10, height: 10)
            }
             
            self.snakeView[0].center.x += CGFloat(dX)
            self.snakeView[0].center.y += CGFloat(dY)
            
        }
    }
    

    
}
