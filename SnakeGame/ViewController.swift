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
    let fieldWidth: CGFloat = 300
    let fieldHeight: CGFloat = 500
    
    var snake = Snake()
    
    // snake step
    let dX: CGFloat = 10
    let dY: CGFloat = 10
    
    var pieceOfSnake = UIView()
    
    var timer = Timer()
    
    var animator = UIDynamicAnimator()
    
    //MARK:- Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createField()
        createSnake()
        moveTheSnake(nil)
        createNewPieceOfSnake()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupCollisions()
    }
    
    //MARK:- move buttons action
    @IBAction func moveRightButton(_ sender: UIButton) {
        timer.invalidate()
        moveTheSnake(sender)
    }

    @IBAction func moveLeftButton(_ sender: UIButton) {
        timer.invalidate()
        moveTheSnake(sender)
    }
    
    @IBAction func moveUpButton(_ sender: UIButton) {
        timer.invalidate()
        moveTheSnake(sender)
    }
    
    @IBAction func moveDownButton(_ sender: UIButton) {
        timer.invalidate()
        moveTheSnake(sender)
    }
    
    //MARK:- field methods
    private func createField() {
        fieldImageView = UIImageView(frame: CGRect(x: view.center.x - fieldWidth / 2, y: view.center.y - fieldHeight / 2, width: fieldWidth, height: fieldHeight))
        fieldImageView.backgroundColor = .lightGray
        view.addSubview(fieldImageView)
    }
    
    //MARK:- snake methods
    private func createSnake() {
        let snakeHead = UIView(frame: CGRect(x: fieldImageView.bounds.minX, y: fieldImageView.bounds.minY, width: snake.pieceWidth, height: snake.pieceHeight))
        snakeHead.backgroundColor = .black
        fieldImageView.addSubview(snakeHead)
        snake.body.append(snakeHead)
        
    }
    //MARK: похоже надо возвращать текующее направление движения, а потом в кнопках проверять доступность поворота
    private func moveTheSnake(_ sender: UIButton?) {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: {(Timer) in
            let currentX = self.snake.body[0].frame.origin.x
            let currentY = self.snake.body[0].frame.origin.y
            
            switch sender?.tag {
            case 0: self.snake.body[0].frame = CGRect(x: currentX - self.dX, y: currentY, width: 10, height: 10)
            case 1: self.snake.body[0].frame = CGRect(x: currentX + self.dX, y: currentY, width: 10, height: 10)
            case 2: self.snake.body[0].frame = CGRect(x: currentX, y: currentY - self.dY, width: 10, height: 10)
            case 3: self.snake.body[0].frame = CGRect(x: currentX, y: currentY + self.dY, width: 10, height: 10)
            case nil: self.snake.body[0].frame = CGRect(x: currentX + self.dX, y: currentY, width: 10, height: 10)
            default: return
            }
        })
    }
    
    //MARK:- new piece of snake methods
    private func getRandomXY(_ fieldWidth: CGFloat, _ fieldHeight: CGFloat) -> (x: CGFloat, y: CGFloat) {
        let randomX = Int.random(in: 0...Int(fieldWidth) / 10) * 10
        let randomY = Int.random(in: 0...Int(fieldHeight) / 10) * 10
        return (CGFloat(randomX), CGFloat(randomY))
    }
    
    private func createNewPieceOfSnake() {
        let randomFieldPoint = getRandomXY(fieldWidth, fieldHeight)
        pieceOfSnake.backgroundColor = .black
        pieceOfSnake.frame = CGRect(x: randomFieldPoint.x, y: randomFieldPoint.y, width: snake.pieceWidth, height: snake.pieceHeight)
        fieldImageView.addSubview(pieceOfSnake)
    }
    
    //MARK:- dynamic animator
    private func setupCollisions() {
        animator = UIDynamicAnimator(referenceView: fieldImageView)        
        let collision = UICollisionBehavior(items: [snake.body[0]])
        collision.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collision)
        collision.addBoundary(withIdentifier: "bottomBoundary" as NSCopying,
                              from: CGPoint(x: 0, y: fieldImageView.bounds.height),
                              to: CGPoint(x: fieldImageView.bounds.width, y: fieldImageView.bounds.height))
        collision.collisionDelegate = self
    }
}

extension ViewController: UICollisionBehaviorDelegate {
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
        print("test")
        let identifier = identifier as? String
        print(identifier)
        let bottomBoundary = "bottomBoundary"
        if identifier == bottomBoundary {
            print("got it")
            snake.body[0].backgroundColor = .red
        }
    }
}

