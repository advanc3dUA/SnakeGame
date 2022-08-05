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
            classicMode = true
        } else {
            classicMode = false
        }
    }
    
    private func loadSettings() {
        if speedUpBool {
            speedUpSwitch.isOn = true
        } else {
            speedUpSwitch.isOn = false
        }
        if classicMode {
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

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
