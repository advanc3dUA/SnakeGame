//
//  ViewController.swift
//  SnakeGame
//
//  Created by advanc3d on 24.07.2022.
//

import UIKit

class ViewController: UIViewController {

    // Variables
    var fieldImageView = UIImageView()
    var piece = UIImageView()
    var timer = Timer()
    lazy var fieldMaxX = fieldImageView.bounds.maxX
    lazy var fieldMaxY = fieldImageView.bounds.maxY
    var snake = Snake()
    
    // Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createField()
        createSnake()
        moveTheSnake(nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    // move buttons action
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
    
    // custom Methods
    private func createField() {
        let width: CGFloat = 300
        let height: CGFloat = 500
        fieldImageView = UIImageView(frame: CGRect(x: view.center.x - width / 2, y: view.center.y - height / 2, width: width, height: height))
        fieldImageView.backgroundColor = .lightGray
        view.addSubview(fieldImageView)
    }
    
    private func createSnake() {
        snake.head = UIImageView(frame: CGRect(x: fieldImageView.bounds.minX, y: fieldImageView.bounds.minY, width: 10, height: 10))
        snake.head.backgroundColor = .black
        fieldImageView.addSubview(snake.head)
    }
    //MARK:- похоже надо возвращать текующее направление движения, а потом в кнопках проверять доступность поворота
    private func moveTheSnake(_ sender: UIButton?) {
        timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true, block: { (Timer) in
            let dX: CGFloat = 10
            let dY: CGFloat = 10
            let currentX = self.snake.head.frame.origin.x
            let currentY = self.snake.head.frame.origin.y
            
            switch sender?.tag {
            case 0: self.snake.head.frame = CGRect(x: currentX - dX, y: currentY, width: 10, height: 10)
            case 1: self.snake.head.frame = CGRect(x: currentX + dX, y: currentY, width: 10, height: 10)
            case 2: self.snake.head.frame = CGRect(x: currentX, y: currentY - dY, width: 10, height: 10)
            case 3: self.snake.head.frame = CGRect(x: currentX, y: currentY + dY, width: 10, height: 10)
            case nil: self.snake.head.frame = CGRect(x: currentX + dX, y: currentY, width: 10, height: 10)
            default: return
            }
        })
    }
}

