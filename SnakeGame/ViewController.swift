//
//  ViewController.swift
//  SnakeGame
//
//  Created by advanc3d on 24.07.2022.
//

import UIKit

class ViewController: UIViewController {

    enum ButtonClicked {
        static var button: CurrentDirection = .right
    }
    
    //MARK:- Variables
    @IBOutlet var moveButtons: [UIButton]!
    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    
    var fieldImageView = UIImageView()
    
    var snakeView: [UIImageView] = []
    
    var newPieceView = UIView()
    
    var displayLink = CADisplayLink()
    
    var timer = Timer()
    var currentdX: Int = 0
    var currentdY: Int = 0
//    var timerTimeInterval = 0.15
//    var moveSnakeDuration = 0.17
    var timerTimeInterval = 0.3
    var moveSnakeDuration = 0.34
    
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
        //setupTimerForMoving(nil)
        createDisplayLink()
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
            ButtonClicked.button = .right
            displayLink.invalidate()
            createDisplayLink()
//            timer.invalidate()
//            setupTimerForMoving(sender)
        }
    }

    @IBAction func moveLeftButton(_ sender: UIButton) {
        guard gameStatus == .running else { return }
        if currentDirection == .up || currentDirection == .down {
            addFeedbackForMovingButtons()
            ButtonClicked.button = .left
            displayLink.invalidate()
            createDisplayLink()
//            timer.invalidate()
//            setupTimerForMoving(sender)
        }
    }
    @IBAction func moveUpButton(_ sender: UIButton) {
        guard gameStatus == .running else { return }
        if currentDirection == .left || currentDirection == .right {
            addFeedbackForMovingButtons()
            ButtonClicked.button = .up
            displayLink.invalidate()
            createDisplayLink()
//            timer.invalidate()
//            setupTimerForMoving(sender)
        }
    }
    
    @IBAction func moveDownButton(_ sender: UIButton) {
        guard gameStatus == .running else { return }
        if currentDirection == .left || currentDirection == .right {
            addFeedbackForMovingButtons()
            ButtonClicked.button = .down
            displayLink.invalidate()
            createDisplayLink()
//            timer.invalidate()
//            setupTimerForMoving(sender)
        }
    }
    
    @IBAction func restartButton(_ sender: UIButton) {
        finishGame()
        snake.eraseBody()
        setupNewGame()
        //setupTimerForMoving(nil)
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
            //setupTimerForMoving(nil)
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
        fieldImageView.layer.borderWidth = CGFloat(PieceOfSnake.width)
        fieldImageView.layer.borderColor = UIColor.red.cgColor
        view.addSubview(fieldImageView)
    }
    
    //MARK:- game methods
    private func setupNewGame() {
        currentdX = 20
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
        timerTimeInterval = 0.3
        moveSnakeDuration = 0.34
    }
    
    private func finishGame() {
        timer.invalidate()
        gameStatus = .lost
        if snake.saveRecord() {
            createAlert()
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
        snakeHeadView.image = snakeImages["head_right"]
        fieldImageView.addSubview(snakeHeadView)
        snakeView.append(snakeHeadView)
    }
    
    //MARK:- new piece methods
    private func createNewPieceOfSnakeView() {
        newPiece = newPiece.createNewPieceOfSnake()
        newPieceView.frame = CGRect(x: newPiece.x, y: newPiece.y, width: PieceOfSnake.width, height: PieceOfSnake.height)
        newPieceView.backgroundColor = .black
        fieldImageView.addSubview(newPieceView)
    }
    
    private func pickupNewPiece(_ newPieceView: UIView) {
        addFeedbackForPickUp()
        scoreLabel.text = "Score: " + String(score)
        UIView.animate(withDuration: 1) {
            newPieceView.backgroundColor = .red
            newPieceView.alpha = 0.1
            self.snakeView.append(UIImageView(frame: CGRect(x: newPieceView.center.x - CGFloat(PieceOfSnake.width / 2),
                                                            y: newPieceView.center.y - CGFloat(PieceOfSnake.height / 2),
                                                            width: CGFloat(PieceOfSnake.width),
                                                            height: CGFloat(PieceOfSnake.height))))
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
    private func createDisplayLink() {
        displayLink = CADisplayLink(target: self, selector: #selector(step))
        displayLink.add(to: .current, forMode: .default)
        
        print("LOG ", displayLink.targetTimestamp)
//        print("LOG: ", displayLink.preferredFramesPerSecond)
//        let actualFramesPerSecond = 1 / (displayLink.targetTimestamp - displayLink.timestamp)
//        print(actualFramesPerSecond)
        
    }
    
    @objc func stepTest() {
        print(ButtonClicked.button)
    }
    
    @objc private func step() {
        var dX = 0
        var dY = 0
        
        switch ButtonClicked.button {
        case .left: dX -= 20
        case .right: dX += 20
        case .up: dY -= 20
        case .down: dY += 20
        }
        currentdX = dX
        currentdY = dY
        
        moveSnake(dX, dY)
        
        rotateHead(currentDirection: snake.body[0].direction!)
        
        if snake.touchedBorders(fieldWidth, fieldHeight) || snake.tailIsTouched() {
            finishGame()
        }
        
        if snake.pickUpNewPiece(newPiece) {
            pickupNewPiece(newPieceView)
        }
    }
    
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
            
            rotateHead(currentDirection: snake.body[0].direction!)
            
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
                                                     width: PieceOfSnake.width,
                                                     height: PieceOfSnake.height)
            }
        }
    }
    
    private func rotateHead(currentDirection: CurrentDirection) {
        switch currentDirection {
        case .right: snakeView[0].image = snakeImages["head_right"]
        case .left: snakeView[0].image = snakeImages["head_left"]
        case .up: snakeView[0].image = snakeImages["head_up"]
        case .down: snakeView[0].image = snakeImages["head_down"]
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
