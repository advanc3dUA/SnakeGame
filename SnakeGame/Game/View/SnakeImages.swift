//
//  SnakeImages.swift
//  SnakeGame
//
//  Created by advanc3d on 20.08.2022.
//

import Foundation
import UIKit

struct ImagesDict {
    static let shared: [String : UIImage] = [
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
}
