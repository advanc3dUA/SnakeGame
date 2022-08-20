//
//  SnakeView.swift
//  SnakeGame
//
//  Created by advanc3d on 20.08.2022.
//

import Foundation
import UIKit

class SnakeView {
    static var shared = [UIImageView]()
    
    private init() { }
    
    static func createSnake() {
        snake.createSnake()

        let snakeHeadView = UIImageView(frame: CGRect(x: Field.shared.bounds.minX + CGFloat(PieceOfSnake.width),
                                                      y: Field.shared.bounds.minY + CGFloat(PieceOfSnake.height),
                                                      width: CGFloat(PieceOfSnake.width),
                                                      height: CGFloat(PieceOfSnake.height)))
        if classicModeBool {
            snakeHeadView.backgroundColor = .black
        } else {
            snakeHeadView.image = ImagesDict.shared["head_right"]
        }
        Field.shared.addSubview(snakeHeadView)
        SnakeView.shared.append(snakeHeadView)
    }

    
}
