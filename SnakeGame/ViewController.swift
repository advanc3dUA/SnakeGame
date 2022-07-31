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
    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    
    var fieldImageView = UIImageView()
    
    var snakeView: [UIView] = []
    
    var newPieceView = UIView()
    
    var timer = Timer()
    var currentdX: Int = 0
    var currentdY: Int = 0
    
    let generator = UISelectionFeedbackGenerator()
    let pickUpGenerator = UIImpactFeedbackGenerator(style: .heavy)
    
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
        guard gameStatus == .running else { return }
        if currentDirection == .up || currentDirection == .down {
            addFeedbackForMovingButtons()
            timer.invalidate()
            setupTimerForMoving(sender)
        }
    }

    @IBAction func moveLeftButton(_ sender: UIButton) {
        guard gameStatus == .running else { return }
        if currentDirection == .up || currentDirection == .down {
            addFeedbackForMovingButtons()
            timer.invalidate()
            setupTimerForMoving(sender)
        }
    }
    @IBAction func moveUpButton(_ sender: UIButton) {
        guard gameStatus == .running else { return }
        if currentDirection == .left || currentDirection == .right {
            addFeedbackForMovingButtons()
            timer.invalidate()
            setupTimerForMoving(sender)
        }
    }
    
    @IBAction func moveDownButton(_ sender: UIButton) {
        guard gameStatus == .running else { return }
        if currentDirection == .left || currentDirection == .right {
            addFeedbackForMovingButtons()
            timer.invalidate()
            setupTimerForMoving(sender)
        }
    }
    
    @IBAction func restartButton(_ sender: UIButton) {
        finishGame()
        snake.eraseBody()
        setupNewGame()
        setupTimerForMoving(nil)
    }
    
    @IBAction func pauseButton(_ sender: UIButton) {
        if timer.isValid {
            timer.invalidate()
            for button in moveButtons {
                button.isUserInteractionEnabled = false
            }
            pauseButton.isSelected = true
            pauseButton.backgroundColor = .yellow
            restartButton.isHidden = true
        } else {
            setupTimerForMoving(nil)
            for button in moveButtons {
                button.isUserInteractionEnabled = true
            }
            pauseButton.isSelected = false
            pauseButton.backgroundColor = .systemPink
            restartButton.isHidden = false
        }
    }
    
   @objc func addFeedbackForMovingButtons() {
        generator.selectionChanged()
    }
    
    func addFeedbackForPickUp() {
        pickUpGenerator.impactOccurred()
    }
    //MARK:- field methods
    private func createField(_ fieldWidth: Int, _ fieldHeight: Int) {
        fieldImageView = UIImageView(frame: CGRect(x: Int(view.center.x) - fieldWidth / 2,
                                                   y: Int(view.center.y) - 350,
                                                   width: fieldWidth,
                                                   height: fieldHeight))
        fieldImageView.backgroundColor = .lightGray
        fieldImageView.layer.masksToBounds = false
        fieldImageView.layer.borderWidth = 10
        fieldImageView.layer.borderColor = UIColor.red.cgColor
        view.addSubview(fieldImageView)
    }
    
    //MARK:- game methods
    private func setupNewGame() {
        currentdX = 10
        currentdY = 0
        snake.setupNewGame()
        snakeView.removeAll()
        createSnake()
        createNewPieceOfSnakeView()
        for button in moveButtons {
            button.alpha = 1.0
        }
        pauseButton.alpha = 1.0
    }
    
    private func finishGame() {
        timer.invalidate()
        
        UIView.animate(withDuration: 0.75) { [unowned self] () in
            for button in moveButtons {
                button.alpha = 0
            }
            pauseButton.alpha = 0
        }
        newPieceView.removeFromSuperview()

        for view in snakeView {
            view.removeFromSuperview()
        }
        snakeView.removeAll()
    }
    
    //MARK:- snake methods
    private func createSnake() {
        snake.createSnake()

        let snakeHeadView = UIView(frame: CGRect(x: fieldImageView.bounds.minX + CGFloat(newPiece.width),
                                                 y: fieldImageView.bounds.minY + CGFloat(newPiece.height),
                                                 width: CGFloat(newPiece.width),
                                                 height: CGFloat(newPiece.height)))
        snakeHeadView.backgroundColor = .black
        fieldImageView.addSubview(snakeHeadView)
        snakeView.append(snakeHeadView)
    }
    
    //MARK:- new piece creating
    private func createNewPieceOfSnakeView() {
        newPiece = newPiece.createNewPieceOfSnake()
        newPieceView.frame = CGRect(x: newPiece.x, y: newPiece.y, width: newPiece.width, height: newPiece.height)
        newPieceView.backgroundColor = .black
        fieldImageView.addSubview(newPieceView)
    }
    
    private func setupTimerForMoving(_ sender: UIButton?) {
        timer = Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true, block: { [unowned self] (Timer) in
            
            var dX = 0
            var dY = 0
            
            switch sender?.tag {
                case 0: dX -= 10
                case 1: dX += 10
                case 2: dY -= 10
                case 3: dY += 10
                case nil: dX += currentdX; dY += currentdY
                default: return
            }
            currentdX = dX
            currentdY = dY
            
            moveSnake(dX, dY)
            
            if snake.touchedBorders(fieldWidth, fieldHeight) || snake.tailIsTouched() {
                gameStatus = .lost
                finishGame()
            }
            
            if snake.pickUpNewPiece(newPiece) {
                pickupNewPiece(newPieceView)
            }
            
        })
    }
    
    private func pickupNewPiece(_ newPieceView: UIView) {
        addFeedbackForPickUp()
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
        UIView.animate(withDuration: 0.17) { [unowned self] in
            
            snake.saveLastPositions()
            snake.moveSnake(dX, dY)
            currentDirection = snake.checkCurrentDirection()

            snakeView[0].center.x += CGFloat(dX)
            snakeView[0].center.y += CGFloat(dY)
            
            for index in 1..<snake.body.count {
                snakeView[index].frame = CGRect(x: snake.body[index - 1].lastX ?? 0,
                                                     y: snake.body[index - 1].lastY ?? 0,
                                                     width: snake.body[index - 1].width,
                                                     height: snake.body[index - 1].height)
            }
        }
    }
    

    
}
