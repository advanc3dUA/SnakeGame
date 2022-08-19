//
//  MenuViewController.swift
//  SnakeGame
//
//  Created by advanc3d on 01.08.2022.
//

import UIKit

class MenuViewController: UIViewController {
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var optionsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        newGameButton.layer.cornerRadius = 10
        optionsButton.layer.cornerRadius = 10
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let record = UserDefaults.standard.integer(forKey: CaseUserDefaults.record)
        
        if record == 0 {
            recordLabel.numberOfLines = 1
            recordLabel.text = "no record detected"
        } else {
            recordLabel.numberOfLines = 2
            //recordLabel.text = String(record) + playerName
            recordLabel.text = """
                                \(String(record))
                                by \(UserDefaults.standard.string(forKey: CaseUserDefaults.playerName)!)
                                """
        }
    }
}
