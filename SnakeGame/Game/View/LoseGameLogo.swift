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
    
//    static func createWastedView() {
//        LoseGameLogo.shared = UIImageView(frame: CGRect(x: Int(fieldImageView.bounds.maxX) / 2 - fieldHeight / 4,
//                                                    y: Int(fieldImageView.bounds.maxY) / 2 - fieldHeight / 4,
//                                                    width: fieldHeight / 2,
//                                                    height: fieldHeight / 2))
//        LoseGameLogo.shared?.alpha = 0.0
//        LoseGameLogo.shared?.image = UIImage(named: "wasted2")
//        fieldImageView.addSubview(LoseGameLogo.shared!)
//    }
    
    static func createWastedView() {
        LoseGameLogo.shared = UIImageView(frame: CGRect(x: fieldWidth / 2 - fieldHeight / 4,
                                                    y: fieldHeight / 2 - fieldHeight / 4,
                                                    width: fieldHeight / 2,
                                                    height: fieldHeight / 2))
        LoseGameLogo.shared?.alpha = 0.0
        LoseGameLogo.shared?.image = UIImage(named: "wasted2")
    }

    static func removeWastedImageView() {
        LoseGameLogo.shared?.removeFromSuperview()
        LoseGameLogo.shared = nil
    }

}
