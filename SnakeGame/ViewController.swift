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
    var timerTimeInterval = 0.15
    var moveSnakeDuration = 0.17
    
    let generator = UISelectionFeedbackGenerator()
    let pickUpGenerator = UIImpactFeedbackGenerator(style: .heavy)
    
    var alert = UIAlertController()
    
    let snakeImages: [String : UIImage] = [
                                            "head_down": UIImage(named: "head_down")!,
                                            "head_up": UIImage(named: "head_up")!,
                                            "head_left": UIImage(named: "head_left")!,
                                            "head_right": UIImage(named: "head_right")!
    ]
    
    //MARK:- Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
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
    
    //MARK:- game methods
    private func setupNewGame() {
        currentdX = 10
        currentdY = 0
        scoreLabel.text = "Score: 0"
        snake.setupNewGame()
        snakeView.removeAll()
        createSnake()
        createNewPieceOfSnakeView()
        for button in moveButtons {
            button.alpha = 1.0
        }
        pauseButton.alpha = 1.0
        timerTimeInterval = 0.15
        moveSnakeDuration = 0.17
    }
    
    private func finishGame() {
        timer.invalidate()
        gameStatus = .lost
        if snake.saveRecord() {
            createAlert()
        }
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

        let snakeHeadView = UIImageView(frame: CGRect(x: fieldImageView.bounds.minX + CGFloat(newPiece.width),
                                                 y: fieldImageView.bounds.minY + CGFloat(newPiece.height),
                                                 width: CGFloat(newPiece.width),
                                                 height: CGFloat(newPiece.height)))
        //snakeHeadView.backgroundColor = .black
        snakeHeadView.image = snakeImages["head_down"]
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
        scoreLabel.text = "Score: " + String(score)
        UIView.animate(withDuration: 1) {
            newPieceView.backgroundColor = .red
            newPieceView.alpha = 0.1
            self.snakeView.append(UIView(frame: CGRect(x: newPieceView.center.x - CGFloat(newPiece.width / 2),
                                                       y: newPieceView.center.y - CGFloat(newPiece.height / 2),
                                                       width: CGFloat(newPiece.width),
                                                       height: CGFloat(newPiece.height))))
            self.snakeView.last?.backgroundColor = .yellow
            self.fieldImageView.addSubview(self.snakeView.last!)
            
            if score % 10 == 0 && speedUpBool {
                self.speedUp()
                self.speedUpAnimation()
                print(self.timerTimeInterval, self.moveSnakeDuration)
            }
            
            newPieceView.removeFromSuperview()
            self.createNewPieceOfSnakeView()
        } completion: { (_) in
            newPieceView.alpha = 1.0
        }

    }
    
    //MARK:- moving snake    
    private func setupTimerForMoving(_ sender: UIButton?) {
        timer = Timer.scheduledTimer(withTimeInterval: timerTimeInterval, repeats: true, block: { [unowned self] (Timer) in
            
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
        UIView.animate(withDuration: moveSnakeDuration) { [unowned self] in
            
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
    
    private func speedUp() {
        timerTimeInterval *= 0.95
        moveSnakeDuration *= 0.95
    }
    
    private func speedUpAnimation() {
        UIView.animate(withDuration: 1.25) { [unowned self] in
            for index in 1...snakeView.count - 1 {
                snakeView[index].backgroundColor = .blue
            }
        } completion: { [unowned self] (finish) in
            for index in 1...snakeView.count - 1 {
                snakeView[index].backgroundColor = .yellow
            }
        }
    }
    
    //MARK:- alert for saving name
    func createAlert() {
        alert = UIAlertController(title: "Congratulations", message: "You've beaten the record!", preferredStyle: .alert)
        alert.addTextField { (textField : UITextField!) in
            textField.placeholder = "Enter your name"
            textField.delegate = self
        }
        
        // save button
        let save = UIAlertAction(title: "Save", style: UIAlertAction.Style.default, handler: { saveAction -> Void in
            let textField = self.alert.textFields![0] as UITextField
            guard let name = textField.text else {
                playerName = ""
                return
            }
            playerName = name
            snake.savePlayerName(name: playerName)
        })
        alert.addAction(save)
        self.present(alert, animated: true, completion: nil)
    }
    //MARK:- constraints
    func setupConstraints() {
        fieldImageView.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 10).isActive = true
        fieldImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        fieldImageView.widthAnchor.constraint(equalToConstant: CGFloat(fieldWidth)).isActive = true
        fieldImageView.heightAnchor.constraint(equalToConstant: CGFloat(fieldHeight)).isActive = true
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
