//
//  OptionsTableViewController.swift
//  SnakeGame
//
//  Created by advanc3d on 02.08.2022.
//

import UIKit


class OptionsTableViewController: UITableViewController {
    
    @IBOutlet weak var resetRecordButton: UIButton!
    @IBOutlet weak var speedUpSwitch: UISwitch!
    @IBOutlet weak var classicModeSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetRecordButton.layer.cornerRadius = 10
        resetRecordButton.setTitleColor(UIColor.black, for: .selected)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadSettings()
    }

    @IBAction func resetRecordAction(_ sender: UIButton) {
        UserDefaults.standard.setValue(0, forKey: CaseUserDefaults.record)
    }
    @IBAction func speedUpSwitch(_ sender: UISwitch) {
        if speedUpSwitch.isOn {
            speedUpBool = true
        } else {
            speedUpBool = false
        }
    }
    @IBAction func classicModeSwitch(_ sender: UISwitch) {
        if classicModeSwitch.isOn {
            classicModeBool = true
        } else {
            classicModeBool = false
        }
    }
    
    private func loadSettings() {
        if speedUpBool {
            speedUpSwitch.isOn = true
        } else {
            speedUpSwitch.isOn = false
        }
        if classicModeBool {
            classicModeSwitch.isOn = true
        } else {
            classicModeSwitch.isOn = false
        }
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
