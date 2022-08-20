//
//  Feedback.swift
//  SnakeGame
//
//  Created by advanc3d on 20.08.2022.
//

import Foundation
import UIKit

class Feedback {
    let moveButtonGenerator = UISelectionFeedbackGenerator()
    let pickUpGenerator = UIImpactFeedbackGenerator(style: .heavy)
    
    func feedbackForMoveButton() {
        moveButtonGenerator.selectionChanged()
    }
    
    func feedbackForPickUp() {
        pickUpGenerator.impactOccurred()
    }
}
