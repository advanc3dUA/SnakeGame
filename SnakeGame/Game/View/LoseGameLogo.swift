//
//  LoseGameLogo.swift
//  SnakeGame
//
//  Created by advanc3d on 19.08.2022.
//

import Foundation
import UIKit

class LoseGameLogo {
    
    static var shared: UIImageView?
    
    static func setup() {
        LoseGameLogo.shared = UIImageView(frame: CGRect(x: fieldWidth / 2 - fieldHeight / 4,
                                                    y: fieldHeight / 2 - fieldHeight / 4,
                                                    width: fieldHeight / 2,
                                                    height: fieldHeight / 2))
        LoseGameLogo.shared?.alpha = 0.0
        LoseGameLogo.shared?.image = UIImage(named: "wasted2")
    }

    static func remove() {
        LoseGameLogo.shared?.removeFromSuperview()
        LoseGameLogo.shared = nil
    }

}
