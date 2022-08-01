//
//  MenuViewController.swift
//  SnakeGame
//
//  Created by advanc3d on 01.08.2022.
//

import UIKit

class MenuViewController: UIViewController {
    @IBOutlet weak var recordLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let record = UserDefaults.standard.integer(forKey: CaseUserDefaults.record)
        
        if record == 0 {
            recordLabel.text = "no record currently"
        } else {
            
        }
        recordLabel.text = String(record)
    }
}
