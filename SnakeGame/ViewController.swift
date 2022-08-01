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
    @IBOutlet weak var scoreLabel: UILabel!
    
    var fieldImageView = UIImageView()
    
    var snakeView: [UIView] = []
    
    var newPieceView = UIView()
    
    var timer = Timer()
    var currentdX: Int = 0
    var currentdY: Int = 0
    
    let generator = UISelectionFeedbackGenerator()
    let pickUpGenerator = UIImpactFeedbackGenerator(style: .heavy)
    
    var score: Int = 0 {
        willSet {
            scoreLabel.text = "Score: " + String(newValue)
        }
    }
    
    //MARK:- Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createField(fieldWidth, fieldHeight)
        setupConstraints()
        setupNewGame()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupTimerForMoving(nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent {
            finishGame()
            snake.eraseBody()
        }
    }
    
    //MARK:- buttons action
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
                button.isHidden = true
            }
            pauseButton.isSelected = true
            pauseButton.backgroundColor = .yellow
            restartButton.isHidden = true
        } else {
            setupTimerForMoving(nil)
            for button in moveButtons {
                button.isHidden = false
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
//        fieldImageView = UIImageView(frame: CGRect(x: Int(view.center.x) - fieldWidth / 2,
//                                                   y: Int(view.center.y) - 410,
//                                                   width: fieldWidth,
//                                                   height: fieldHeight))
        fieldImageView = UIImageView(frame: CGRect(x: 0,
                                                   y: 0,
                                                   width: 0,
                                                   height: 0))
        fieldImageView.translatesAutoresizingMaskIntoConstraints = false
        fieldImageView.backgroundColor = .lightGray
        fieldImageView.layer.masksToBounds = false
        fieldImageView.layer.borderWidth = 10
        fieldImageView.layer.borderColor = UIColor.red.cgColor
        view.addSubview(fieldImageView)
    }
    
    private func resetScoreClock() {
        scoreLabel.text = "Score: 0"
    }
    
    //MARK:- game methods
    private func setupNewGame() {
        currentdX = 10
        currentdY = 0
        score = 0
        resetScoreClock()
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
        gameStatus = .lost
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
    
    //MARK:- new piece methods
    private func createNewPieceOfSnakeView() {
        newPiece = newPiece.createNewPieceOfSnake()
        newPieceView.frame = CGRect(x: newPiece.x, y: newPiece.y, width: newPiece.width, height: newPiece.height)
        newPieceView.backgroundColor = .black
        fieldImageView.addSubview(newPieceView)
    }
    
    private func pickupNewPiece(_ newPieceView: UIView) {
        addFeedbackForPickUp()
        score += 1
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
    
    //MARK:- moving snake    
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
                finishGame()
            }
            
            if snake.pickUpNewPiece(newPiece) {
                pickupNewPiece(newPieceView)
            }
            
        })
    }
    
    private func moveSnake(_ dX: Int, _ dY: Int) {
        UIView.animate(withDuration: 0.17) { [unowned self] in
            
            snake.saveLastPositions()
            snake.moveSnake(dX, dY)
            currentDirection = snake.checkCurrentDirection()

            snakeView[0].center.x += CGFloat(dX)
            snakeView[0].center.y += CGFloat(dY)
            
            print(snake.body.count)
            for index in 1..<snake.body.count {
                snakeView[index].frame = CGRect(x: snake.body[index - 1].lastX ?? 0,
                                                     y: snake.body[index - 1].lastY ?? 0,
                                                     width: snake.body[index - 1].width,
                                                     height: snake.body[index - 1].height)
            }
        }
    }
    
    //MARK:- constraints
    func setupConstraints() {
//        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
//        scoreLabel.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
//        scoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        scoreLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
//        scoreLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        fieldImageView.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 10).isActive = true
        fieldImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        fieldImageView.widthAnchor.constraint(equalToConstant: CGFloat(fieldWidth)).isActive = true
        fieldImageView.heightAnchor.constraint(equalToConstant: CGFloat(fieldHeight)).isActive = true
    }
}
