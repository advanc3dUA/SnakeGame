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
    @IBOutlet weak var levelLabel: UILabel!
    
    var fieldImageView = UIImageView()
    var wastedLabel: UILabel?
    
    var snakeView: [UIImageView] = []
    
    var newPieceView = UIImageView()
    
    var timer: Timer?
    var currentdX: Int = 0
    var currentdY: Int = 0
    
    let timerTimeIntervalConst = 0.3
    let moveSnakeDurationConst = 0.4
    lazy var timerTimeInterval = timerTimeIntervalConst
    lazy var moveSnakeDuration = moveSnakeDurationConst
    
    let generator = UISelectionFeedbackGenerator()
    let pickUpGenerator = UIImpactFeedbackGenerator(style: .heavy)
    
    var alert = UIAlertController()
    
    let snakeImages: [String : UIImage] = [
                                            "head_down": UIImage(named: "head_down")!,
                                            "head_up": UIImage(named: "head_up")!,
                                            "head_left": UIImage(named: "head_left")!,
                                            "head_right": UIImage(named: "head_right")!,
                                            "body_horizontal": UIImage(named: "body_horizontal")!,
                                            "body_vertical": UIImage(named: "body_vertical")!,
                                            "tail_down": UIImage(named: "tail_down")!,
                                            "tail_up": UIImage(named: "tail_up")!,
                                            "tail_left": UIImage(named: "tail_left")!,
                                            "tail_right": UIImage(named: "tail_right")!,
                                            "apple": UIImage(named: "apple")!
        
    ]
    
    //MARK:- Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createField(fieldWidth, fieldHeight)
        
        restartButton.layer.cornerRadius = 10
        pauseButton.layer.cornerRadius = 10
        levelLabel.clipsToBounds = true
        scoreLabel.clipsToBounds = true
        levelLabel.layer.cornerRadius = 10
        scoreLabel.layer.cornerRadius = 10
        
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
            cancelTimer()
            setupTimerForMoving(sender)
        }
    }

    @IBAction func moveLeftButton(_ sender: UIButton) {
        guard gameStatus == .running else { return }
        if currentDirection == .up || currentDirection == .down {
            addFeedbackForMovingButtons()
            cancelTimer()
            setupTimerForMoving(sender)
        }
    }
    @IBAction func moveUpButton(_ sender: UIButton) {
        guard gameStatus == .running else { return }
        if currentDirection == .left || currentDirection == .right {
            addFeedbackForMovingButtons()
            cancelTimer()
            setupTimerForMoving(sender)
        }
    }
    
    @IBAction func moveDownButton(_ sender: UIButton) {
        guard gameStatus == .running else { return }
        if currentDirection == .left || currentDirection == .right {
            addFeedbackForMovingButtons()
            cancelTimer()
            setupTimerForMoving(sender)
        }
    }
    
    @IBAction func restartButton(_ sender: UIButton) {
        removeWastedLabel()
        finishGame()
        snake.eraseBody()
        setupNewGame()
        setupTimerForMoving(nil)
    }
    
    @IBAction func pauseButton(_ sender: UIButton) {
        if timer!.isValid {
            timer?.invalidate()
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
            pauseButton.backgroundColor = .lightGray
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
        fieldImageView.backgroundColor = .white
        fieldImageView.layer.masksToBounds = false
        fieldImageView.layer.borderWidth = CGFloat(PieceOfSnake.width)
        fieldImageView.layer.borderColor = UIColor.lightGray.cgColor
        view.addSubview(fieldImageView)
    }
    
    private func createWastedLabel() {
        wastedLabel = UILabel(frame: CGRect(x: fieldImageView.bounds.maxX / 2 - 50,
                                            y: fieldImageView.bounds.maxY / 2 - 25,
                                            width: 100,
                                            height: 50))
        wastedLabel?.alpha = 0.0
        wastedLabel?.clipsToBounds = true
        wastedLabel?.layer.cornerRadius = 10
        wastedLabel?.textAlignment = .center
        wastedLabel?.text = "Wasted"
        wastedLabel?.backgroundColor = .lightGray
        wastedLabel?.textColor = .systemBlue
        wastedLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        fieldImageView.addSubview(wastedLabel!)
    }
    
    private func removeWastedLabel() {
        wastedLabel?.removeFromSuperview()
        wastedLabel = nil
    }
    
    //MARK:- game methods
    private func setupNewGame() {
        currentdX = 20
        currentdY = 0
        scoreLabel.text = "Score: 0"
        levelLabel.text = "Level: 1"
        removeWastedLabel()
        snake.setupNewGame()
        snakeView.removeAll()
        createSnake()
        createNewPieceOfSnakeView()
        for button in moveButtons {
            button.alpha = 1.0
        }
        pauseButton.alpha = 1.0
        timerTimeInterval = timerTimeIntervalConst
        moveSnakeDuration = moveSnakeDurationConst
    }
    
    private func finishGame() {
        createWastedLabel()
        UIView.animate(withDuration: 1) {
            self.wastedLabel?.alpha = 1.0
        }
        cancelTimer()
        gameStatus = .lost
        if speedUpBool {
            if snake.saveRecord() {
                createAlert()
            }
        }
        UIView.animate(withDuration: 1) { [unowned self] () in
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

        let snakeHeadView = UIImageView(frame: CGRect(x: fieldImageView.bounds.minX + CGFloat(PieceOfSnake.width),
                                                      y: fieldImageView.bounds.minY + CGFloat(PieceOfSnake.height),
                                                      width: CGFloat(PieceOfSnake.width),
                                                      height: CGFloat(PieceOfSnake.height)))
        if classicModeBool {
            snakeHeadView.backgroundColor = .black
        } else {
            snakeHeadView.image = snakeImages["head_right"]
        }
        fieldImageView.addSubview(snakeHeadView)
        snakeView.append(snakeHeadView)
    }
    
    //MARK:- new piece methods
    private func createNewPieceOfSnakeView() {
        newPiece = newPiece.createNewPieceOfSnake()
        newPieceView.frame = CGRect(x: newPiece.x, y: newPiece.y, width: PieceOfSnake.width, height: PieceOfSnake.height)
        if classicModeBool {
            newPieceView.backgroundColor = .black
        } else {
            newPieceView.image = snakeImages["apple"]
        }
        fieldImageView.addSubview(newPieceView)
    }
    
    private func pickupNewPiece(_ newPieceView: UIView) {
        addFeedbackForPickUp()
        scoreLabel.text = "Score: " + String(score)
        UIView.animate(withDuration: 1) {
            if classicModeBool {
                newPieceView.backgroundColor = .red
            }
            newPieceView.alpha = 0.1
            self.snakeView.append(UIImageView(frame: CGRect(x: newPieceView.center.x - CGFloat(PieceOfSnake.width / 2),
                                                            y: newPieceView.center.y - CGFloat(PieceOfSnake.height / 2),
                                                            width: CGFloat(PieceOfSnake.width),
                                                            height: CGFloat(PieceOfSnake.height))))
            if classicModeBool {
                self.snakeView.last?.backgroundColor = .yellow
            }
            self.fieldImageView.addSubview(self.snakeView.last!)
            
            if score % 10 == 0 && speedUpBool {
                self.speedUp()
                self.goingNextLevel()
            }
            
            newPieceView.removeFromSuperview()
            self.createNewPieceOfSnakeView()
        } completion: { (_) in
            if classicModeBool {
                newPieceView.backgroundColor = .black
            } else {
                newPieceView.backgroundColor = nil
            }
            newPieceView.alpha = 1.0
        }

    }
    
    private func goingNextLevel() {
        level += 1
        self.levelLabel.text = "Level: " + String(level)
        levelLabel.flash(numberOfFlashes: 4)
        for view in snakeView {
            view.flash(numberOfFlashes: 3)
        }
    }
    
    //MARK:- moving snake
    private func setupTimerForMoving(_ sender: UIButton?) {
        timer = Timer.scheduledTimer(withTimeInterval: timerTimeInterval, repeats: true, block: { [unowned self] (Timer) in
            
            var dX = 0
            var dY = 0
            
            switch sender?.tag {
                case 0: dX -= 20
                case 1: dX += 20
                case 2: dY -= 20
                case 3: dY += 20
                case nil: dX += currentdX; dY += currentdY
                default: return
            }
            currentdX = dX
            currentdY = dY
            
            moveSnake(dX, dY)
            
            if classicModeBool == false {
                rotateHead(snake.body)
                rotateBody(snake.body)
                rotateTale(snake.body)
            }
            
            if snake.touchedBorders(fieldWidth, fieldHeight) || snake.tailIsTouched() {
                finishGame()
            }
            
            if snake.pickUpNewPiece(newPiece) {
                pickupNewPiece(newPieceView)
            }
            
        })
        RunLoop.current.add(timer!, forMode: .common)
    }
    
    private func cancelTimer() {
        timer?.invalidate()
        timer = nil
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
                                                     width: PieceOfSnake.width,
                                                     height: PieceOfSnake.height)
            }
        }
    }
    
    private func rotateHead(_ body: [PieceOfSnake]) {
        
        guard let headDirection = body[0].direction else { return }
        switch headDirection {
        case .right: snakeView[0].image = snakeImages["head_right"]
        case .left: snakeView[0].image = snakeImages["head_left"]
        case .up: snakeView[0].image = snakeImages["head_up"]
        case .down: snakeView[0].image = snakeImages["head_down"]
        }
    }
    

    fileprivate func rotateBody(_ body: [PieceOfSnake]) {
        guard body.count > 2 else { return }
        for index in 1...body.endIndex - 2 {
            guard let bodyPartDirection = body[index].direction else { return }
            guard let previousPartDirection = body[index - 1].direction else { return }
            switch (bodyPartDirection, previousPartDirection) {
            case (.left, _): snakeView[index].image = snakeImages["body_horizontal"]
            case (.right, _): snakeView[index].image = snakeImages["body_horizontal"]
            case (.up, _): snakeView[index].image = snakeImages["body_vertical"]
            case (.down, _): snakeView[index].image = snakeImages["body_vertical"]
            }
        }
    }
    
    fileprivate func rotateTale(_ body: [PieceOfSnake]) {
        guard body.count > 1 else { return }
        guard let taleDirection = body[body.endIndex - 1].direction else { return }
        switch taleDirection {
        case .left: snakeView[body.endIndex - 1].image = snakeImages["tail_right"]
        case .right: snakeView[body.endIndex - 1].image = snakeImages["tail_left"]
        case .down: snakeView[body.endIndex - 1].image = snakeImages["tail_up"]
        case .up: snakeView[body.endIndex - 1].image = snakeImages["tail_down"]
        }
    }
    
    
    private func speedUp() {
        timerTimeInterval *= 0.95
        moveSnakeDuration *= 0.95
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
            if name == "" {
                playerName = "unknown hero"
            } else {
                playerName = name
            }
            snake.savePlayerName(name: playerName)
        })
        alert.addAction(save)
        self.present(alert, animated: true, completion: nil)
    }
    //MARK:- constraints
    func setupConstraints() {
        fieldImageView.topAnchor.constraint(equalTo: levelLabel.bottomAnchor, constant: 20).isActive = true
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

//MARK:- flashing method
extension UIView {
        func flash(numberOfFlashes: Float) {
           let flash = CABasicAnimation(keyPath: "opacity")
           flash.duration = 0.2
           flash.fromValue = 1
           flash.toValue = 0.1
           flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
           flash.autoreverses = true
           flash.repeatCount = numberOfFlashes
           layer.add(flash, forKey: nil)
       }
 }
