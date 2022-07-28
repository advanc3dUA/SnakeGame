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
        let newPiece = snake.createNewPieceOfSnake()
        newPieceView.frame = CGRect(x: newPiece.x, y: newPiece.y, width: newPiece.width, height: newPiece.height)
        newPieceView.backgroundColor = .black
        fieldImageView.addSubview(newPieceView)
    }
    //MARK: похоже надо возвращать текующее направление движения, а потом в кнопках проверять доступность поворота
    private func setupTimerForMoving(_ sender: UIButton?) {
        timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true, block: {(Timer) in
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
        })
    }
    private func moveSnake(_ dX: Int, _ dY: Int) {
        UIView.animate(withDuration: 0.3) {
            snake.body[0].x += dX
            snake.body[0].y += dY
             
            self.snakeView[0].center.x += CGFloat(dX)
            self.snakeView[0].center.y += CGFloat(dY)
        }
    }
    

    
}
