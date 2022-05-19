//
//  SettingsTableControllerTableViewController.swift
//  strokeRehab
//
//  Created by mobiledev on 18/5/2022.
//

import UIKit

struct DefaultKeys {
    static let name = "nameStringKey"
    static let normalReps = "normalRepsStringKey"
    static let normalTime = "normalTime"
    static let normalNumButtons = "normalNum"
    static let normalRandom = "normalRandom"
    static let normalHighlightNext = "normalHighlightNext"
    static let normalSize = "normalSize"
    static let sliderReps = "sliderReps"
    static let sliderTime = "sliderTime"
    static let sliderRandom = "sliderRandom"
    static let sliderNotches = "sliderNotches"
}

class SettingsTableControllerTableViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet var settingsTableView: UITableView!
    @IBOutlet var nameTextFeild: UITextField!
    
    @IBOutlet var normalGoalsButton: UIButton!
    @IBOutlet var normalTimeButton: UIButton!
    @IBOutlet var normalNumberButton: UIButton!
    @IBOutlet var normalSizeButton: UIButton!
    
    @IBOutlet var sliderRepsButton: UIButton!
    @IBOutlet var sliderTimeButton: UIButton!
    @IBOutlet var sliderNumNotchesButton: UIButton!
    
    
    @IBAction func nameEntered(_ sender: UITextField) {
        let defaults = UserDefaults.standard
        let name = sender.attributedText?.string ?? "user"
        print("Hello ", name)
        defaults.set(name, forKey: DefaultKeys.name)
    }
    
    @IBOutlet var normalRandomSwitch: UISwitch!
    @IBAction func normalRandomOrderChanged(_ sender: UISwitch) {
        let defaults = UserDefaults.standard
        let value = sender.isOn
        print("Set to ", value)
        defaults.set(value, forKey: DefaultKeys.normalRandom)
    }
    
    @IBOutlet var normalHighlightSwitch: UISwitch!
    @IBAction func normalHighlightChanged(_ sender: UISwitch) {
        let defaults = UserDefaults.standard
        let value = sender.isOn
        print("Set to ", value)
        defaults.set(value, forKey: DefaultKeys.normalHighlightNext)
    }
    
    @IBOutlet var sliderRandomSwitch: UISwitch!
    @IBAction func sliderRandomOrderChanged(_ sender: UISwitch) {
        let defaults = UserDefaults.standard
        let value = sender.isOn
        print("Set to ", value)
        defaults.set(value, forKey: DefaultKeys.sliderRandom)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //setup switches and text fields
        let defaults = UserDefaults.standard
        if let name = defaults.string(forKey: DefaultKeys.name) {
            nameTextFeild.text = name
        }
        else {
            nameTextFeild.text = "Nick O'Teen"
        }
        
        
        normalRandomSwitch.isOn = defaults.bool(forKey: DefaultKeys.normalRandom)
        normalHighlightSwitch.isOn = defaults.bool(forKey: DefaultKeys.normalHighlightNext)
        sliderRandomSwitch.isOn = defaults.bool(forKey: DefaultKeys.sliderRandom)
        
        
        
        //setup multi options
        setupOptions(button: normalGoalsButton, options: ["No goal", "3", "5", "20", "20"], title: "Number of Repetitions (Goal)", userDefaultsKey: DefaultKeys.normalReps)
        
        setupOptions(button: normalTimeButton, options: ["No time limit", "10", "30", "60"], title: "Time limit (seconds)", userDefaultsKey: DefaultKeys.normalTime)
        
        setupOptions(button: normalNumberButton, options: ["2", "3", "4", "5"], title: "Number of buttons", userDefaultsKey: DefaultKeys.normalNumButtons)
        
        setupOptions(button: normalSizeButton, options: ["S", "M", "L", "XL"], title: "Button Size", userDefaultsKey: DefaultKeys.normalSize)
        
        setupOptions(button: sliderRepsButton, options: ["No goal", "3", "5", "20", "20"], title: "Number of Repetitions (Goal)", userDefaultsKey: DefaultKeys.sliderReps)
        
        setupOptions(button: sliderTimeButton, options: ["No time limit", "10", "30", "60"], title: "Time limit (seconds)", userDefaultsKey: DefaultKeys.sliderTime)
        
        setupOptions(button: sliderNumNotchesButton, options: ["2", "3", "4", "5"], title: "Number of Notches", userDefaultsKey: DefaultKeys.sliderNotches)
        
    
    }
    
    
    
    //sets up options for a settings button
    func setupOptions(button: UIButton, options: [String], title: String, userDefaultsKey: String) {
        var optionActions: [UIAction] = []
        let defaults = UserDefaults.standard
        
        var selected = options[0]
        //get the saved user defaults
        if let name = defaults.string(forKey: userDefaultsKey) {
            selected = name
        }
        
        
        
        for option in options {
            
            var state = UIMenuElement.State.off
            if option == selected {
                state = UIMenuElement.State.on
            }
            
            optionActions.append(UIAction(title:option, state: state) { (action) in
                
                
                print("Selected ", option)
                
                defaults.set(option, forKey: userDefaultsKey)
            })
        }
        
        button.menu = UIMenu(title: title, options: .displayInline, children: optionActions)

        button.showsMenuAsPrimaryAction = true
        
        
        
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        switch section {
        case 0:
            return 1
        case 1:
            return 6
        case 2:
            return 4
        default:
            return 0
        }

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
