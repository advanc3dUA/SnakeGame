//
//  LoseGameLogo.swift
//  SnakeGame
//
//  Created by advanc3d on 19.08.2022.
//

import Foundation
import UIKit

class LoseGameLogo {
    
    static var imageView: UIImageView?
    
    static func setup() {
        LoseGameLogo.imageView = UIImageView(frame: CGRect(x: fieldWidth / 2 - fieldHeight / 4,
                                                    y: fieldHeight / 2 - fieldHeight / 4,
                                                    width: fieldHeight / 2,
                                                    height: fieldHeight / 2))
        LoseGameLogo.imageView?.alpha = 0.0
        LoseGameLogo.imageView?.image = UIImage(named: "wasted2")
    }

    static func remove() {
        LoseGameLogo.imageView?.removeFromSuperview()
        LoseGameLogo.imageView = nil
    }

}
