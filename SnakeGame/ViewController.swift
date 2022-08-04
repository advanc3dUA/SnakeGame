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
    
    var snakeView: [UIImageView] = []
    
    var newPieceView = UIView()
    
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
                                            "body_bottomleft": UIImage(named: "body_bottomleft")!,
                                            "body_bottomright": UIImage(named: "body_bottomright")!,
                                            "body_horizontal": UIImage(named: "body_horizontal")!,
                                            "body_topleft": UIImage(named: "body_topleft")!,
                                            "body_topright": UIImage(named: "body_topright")!,
                                            "body_vertical": UIImage(named: "body_vertical")!
        
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
        timerTimeInterval = timerTimeIntervalConst
        moveSnakeDuration = moveSnakeDurationConst
    }
    
    private func finishGame() {
        cancelTimer()
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
            
            rotateHead(snake.body)
            rotateBody(snake.body)
            
            
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
    
//    fileprivate func rotateBody(_ body: [PieceOfSnake]) {
//        guard body.count > 1 else { return }
//        for index in 1...body.endIndex - 1 {
//            guard let bodyPartDirection = body[index].direction else { return }
//            guard let previousPartDirection = body[index - 1].direction else { return }
//            switch (bodyPartDirection, previousPartDirection) {
//            case (.right, .down): snakeView[index].image = snakeImages["body_bottomleft"]
//            case (.up, .left): snakeView[index].image = snakeImages["body_bottomleft"]
//            case (.left, .down): snakeView[index].image = snakeImages["body_bottomright"]
//            case (.up, .right): snakeView[index].image = snakeImages["body_bottomright"]
//            case (.right, .up): snakeView[index].image = snakeImages["body_topleft"]
//            case (.down, .left): snakeView[index].image = snakeImages["body_topleft"]
//            case (.down, .right): snakeView[index].image = snakeImages["body_topright"]
//            case (.left, .up): snakeView[index].image = snakeImages["body_topright"]
//            case (.left, _): snakeView[index].image = snakeImages["body_horizontal"]
//            case (.right, _): snakeView[index].image = snakeImages["body_horizontal"]
//            case (.up, _): snakeView[index].image = snakeImages["body_vertical"]
//            case (.down, _): snakeView[index].image = snakeImages["body_vertical"]
//            }
//        }
//    }
    fileprivate func rotateBody(_ body: [PieceOfSnake]) {
        guard body.count > 1 else { return }
        for index in 0...body.count - 2 {
            guard let bodyPartDirection = body[index].direction else { return }
            guard let nextPartDirection = body[index + 1].direction else { return }
            switch (bodyPartDirection, nextPartDirection) {
            case (.down, .right): snakeView[index + 1].image = snakeImages["body_bottomleft"]
            case (.left, .up): snakeView[index + 1].image = snakeImages["body_bottomleft"]
            case (.right, .up): snakeView[index + 1].image = snakeImages["body_bottomright"]
            case (.down, .left): snakeView[index + 1].image = snakeImages["body_bottomright"]
            case (.up, .right): snakeView[index + 1].image = snakeImages["body_topleft"]
            case (.left, .down): snakeView[index + 1].image = snakeImages["body_topleft"]
            case (.right, .down): snakeView[index + 1].image = snakeImages["body_topright"]
            case (.up, .left): snakeView[index + 1].image = snakeImages["body_topright"]
            case (.left, _): snakeView[index + 1].image = snakeImages["body_horizontal"]
            case (.right, _): snakeView[index + 1].image = snakeImages["body_horizontal"]
            case (.up, _): snakeView[index + 1].image = snakeImages["body_vertical"]
            case (.down, _): snakeView[index + 1].image = snakeImages["body_vertical"]
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
                snakeView[index].backgroundColor = nil
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
