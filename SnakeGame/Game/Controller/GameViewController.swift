//
//  ViewController.swift
//  SnakeGame
//
//  Created by advanc3d on 24.07.2022.
//

import UIKit

class GameViewController: UIViewController {

    //MARK:- Variables
    @IBOutlet var moveButtons: [UIButton]!
    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    
    var snakeView: [UIImageView] = []
    
    var newPieceView = UIImageView()
    
    var timer: Timer?
    var currentdX: Int = 0
    var currentdY: Int = 0
    
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
    
    //MARK:- standart methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Field.create(controller: self)
        roundingCornersOfAllElements()
        Field.setupConstraints(controller: self)
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
        guard Game.status == .started else { return }
        if snake.body[0].direction == .up || snake.body[0].direction == .down {
            movingButtonAction(sender)
        }
    }

    @IBAction func moveLeftButton(_ sender: UIButton) {
        guard Game.status == .started else { return }
        if snake.body[0].direction == .up || snake.body[0].direction == .down {
            movingButtonAction(sender)
        }
    }
    @IBAction func moveUpButton(_ sender: UIButton) {
        guard Game.status == .started else { return }
        if snake.body[0].direction == .left || snake.body[0].direction == .right {
            movingButtonAction(sender)
        }
    }
    
    @IBAction func moveDownButton(_ sender: UIButton) {
        guard Game.status == .started else { return }
        if snake.body[0].direction == .left || snake.body[0].direction == .right {
            movingButtonAction(sender)
        }
    }
    
    private func movingButtonAction(_ sender: UIButton) {
        addFeedbackForMovingButtons()
        cancelTimer()
        setupTimerForMoving(sender)
    }
    
    @IBAction func restartButton(_ sender: UIButton) {
        LoseGameLogo.remove()
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
    
    //MARK:- vibrating on click & pick
    func addFeedbackForMovingButtons() {
        generator.selectionChanged()
    }
    
    func addFeedbackForPickUp() {
        pickUpGenerator.impactOccurred()
    }
    
    private func setupMovingButtons() {
        for button in moveButtons {
            button.alpha = 1.0
            button.clipsToBounds = true
            button.layer.cornerRadius = 5
        }
    }
    
    private func roundingCornersOfAllElements() {
        restartButton.layer.cornerRadius = 5
        pauseButton.layer.cornerRadius = 5
        levelLabel.clipsToBounds = true
        scoreLabel.clipsToBounds = true
        levelLabel.layer.cornerRadius = 5
        scoreLabel.layer.cornerRadius = 5
        Field.shared.layer.cornerRadius = 10
    }
    
    //MARK:- game methods
    private func setupNewGame() {
        currentdX = 20
        currentdY = 0
        scoreLabel.text = "Score: 0"
        levelLabel.text = "Level: 1"
        LoseGameLogo.remove()
        Game.setupNewGame()
        snakeView.removeAll()
        createSnake()
        createNewPieceOfSnakeView()
        setupMovingButtons()
        pauseButton.alpha = 1.0
        timerTimeInterval = timerTimeIntervalConst
        moveSnakeDuration = moveSnakeDurationConst
    }
    
    private func finishGame() {
        LoseGameLogo.setup()
        Field.shared.addSubview(LoseGameLogo.imageView ?? UIImageView())
        UIView.animate(withDuration: 1.5) {
            LoseGameLogo.imageView?.alpha = 1.0
        }
        cancelTimer()
        Game.status = .lost
        if speedUpBool {
            if Record.saveRecord() {
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
    
    private func goingNextLevel() {
        level += 1
        levelLabel.text = "Level: " + String(level)
        levelLabel.flash(numberOfFlashes: 4)
        for view in snakeView {
            view.flash(numberOfFlashes: 3)
        }
    }
    
    //MARK:- snake methods
    private func createSnake() {
        snake.createSnake()

        let snakeHeadView = UIImageView(frame: CGRect(x: Field.shared.bounds.minX + CGFloat(PieceOfSnake.width),
                                                      y: Field.shared.bounds.minY + CGFloat(PieceOfSnake.height),
                                                      width: CGFloat(PieceOfSnake.width),
                                                      height: CGFloat(PieceOfSnake.height)))
        if classicModeBool {
            snakeHeadView.backgroundColor = .black
        } else {
            snakeHeadView.image = snakeImages["head_right"]
        }
        Field.shared.addSubview(snakeHeadView)
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
        Field.shared.addSubview(newPieceView)
    }
    
    private func pickupNewPiece(_ newPieceView: UIView) {
        addFeedbackForPickUp()
        scoreLabel.text = "Score: " + String(score)
        UIView.animate(withDuration: 1) { [unowned self] in
            if classicModeBool {
                newPieceView.backgroundColor = .red
            }
            newPieceView.alpha = 0.1
            snakeView.append(UIImageView(frame: CGRect(x: newPieceView.center.x - CGFloat(PieceOfSnake.width / 2),
                                                            y: newPieceView.center.y - CGFloat(PieceOfSnake.height / 2),
                                                            width: CGFloat(PieceOfSnake.width),
                                                            height: CGFloat(PieceOfSnake.height))))
            if classicModeBool {
                snakeView.last?.backgroundColor = .yellow
            }
            Field.shared.addSubview(snakeView.last!)
            
            if score % 10 == 0 && speedUpBool {
                speedUp()
                goingNextLevel()
            }
            
            newPieceView.removeFromSuperview()
            createNewPieceOfSnakeView()
        } completion: { (_) in
            if classicModeBool {
                newPieceView.backgroundColor = .black
            } else {
                newPieceView.backgroundColor = nil
            }
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
            
            if classicModeBool == false {
                rotateHead()
                rotateBody()
                rotateTale()
            }
            
            if snake.touchedBorders() || snake.tailIsTouched() {
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
    
    private func speedUp() {
        timerTimeInterval *= 0.95
        moveSnakeDuration *= 0.95
    }
    
    private func moveSnake(_ dX: Int, _ dY: Int) {
        UIView.animate(withDuration: moveSnakeDuration) { [unowned self] in

            snake.saveLastPositions()
            snake.moveSnake(dX, dY)
            snake.body[0].direction = snake.checkDirection()

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
    
    private func rotateHead() {
        
        guard let headDirection = snake.body[0].direction else { return }
        switch headDirection {
        case .right: transition(indexOfImageView: 0, to: "head_right")
        case .left: transition(indexOfImageView: 0, to: "head_left")
        case .up: transition(indexOfImageView: 0, to: "head_up")
        case .down: transition(indexOfImageView: 0, to: "head_down")
        }
    }
    

    fileprivate func rotateBody() {
        guard snake.body.count > 2 else { return }
        for index in 1...snake.body.endIndex - 2 {
            guard let bodyPartDirection = snake.body[index].direction else { return }
            guard let previousPartDirection = snake.body[index - 1].direction else { return }
            switch (bodyPartDirection, previousPartDirection) {
            case (.left, _): transition(indexOfImageView: index, to: "body_horizontal")
            case (.right, _): transition(indexOfImageView: index, to: "body_horizontal")
            case (.up, _): transition(indexOfImageView: index, to: "body_vertical")
            case (.down, _): transition(indexOfImageView: index, to: "body_vertical")
            }
        }
    }
    
    fileprivate func rotateTale() {
        guard snake.body.count > 1 else { return }
        guard let taleIndex = snakeView.lastIndex(of: snakeView.last!) else { return }
        guard let taleDirection = snake.body[taleIndex].direction else { return }
        switch taleDirection {
        case .left: transition(indexOfImageView: taleIndex, to: "tail_right")
        case .right: transition(indexOfImageView: taleIndex, to: "tail_left")
        case .down: transition(indexOfImageView: taleIndex, to: "tail_up")
        case .up: transition(indexOfImageView: taleIndex, to: "tail_down")
        }
    }
    
    fileprivate func transition(indexOfImageView: Int, to imageName: String) {
        UIView.transition(with: snakeView[indexOfImageView],
                          duration: 0.1,
                          options: [.beginFromCurrentState, .curveEaseOut]) {
            self.snakeView[indexOfImageView].image = self.snakeImages[imageName]
        }
    }
}


