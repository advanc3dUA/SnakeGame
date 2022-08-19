//
//  Field.swift
//  SnakeGame
//
//  Created by advanc3d on 19.08.2022.
//

import Foundation
import UIKit

class Field {
    private init() {}
    static var shared = UIImageView()
    
    static func create(controller: UIViewController) {
        Field.shared = UIImageView(frame: CGRect(x: 0,
                                                   y: 0,
                                                   width: 0,
                                                   height: 0))
        Field.shared.translatesAutoresizingMaskIntoConstraints = false
        Field.shared.backgroundColor = .white
        Field.shared.layer.masksToBounds = false
        Field.shared.layer.borderWidth = CGFloat(PieceOfSnake.width)
        Field.shared.layer.borderColor = UIColor.lightGray.cgColor
        controller.view.addSubview(Field.shared)
    }
    
    static func setupConstraints(controller: UIViewController) {
        guard let gameVC = controller as? GameViewController else { return }
        Field.shared.topAnchor.constraint(equalTo: gameVC.levelLabel.bottomAnchor, constant: 20).isActive = true
        Field.shared.centerXAnchor.constraint(equalTo: gameVC.view.centerXAnchor).isActive = true
        Field.shared.widthAnchor.constraint(equalToConstant: CGFloat(fieldWidth)).isActive = true
        Field.shared.heightAnchor.constraint(equalToConstant: CGFloat(fieldHeight)).isActive = true
    }
    
}
