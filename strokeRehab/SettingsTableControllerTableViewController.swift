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
}

class SettingsTableControllerTableViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet var settingsTableView: UITableView!
    @IBOutlet var nameTextFeild: UITextField!
    
    @IBOutlet var normalGoalsButton: UIButton!
    
    
    @IBAction func nameEntered(_ sender: UITextField) {
        let defaults = UserDefaults.standard
        
        let name = sender.attributedText?.string ?? "user"
        print("Hello ", name)
        
        defaults.set(name, forKey: DefaultKeys.name)
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let defaults = UserDefaults.standard
        if let name = defaults.string(forKey: DefaultKeys.name) {
            nameTextFeild.text = name
        }
        else {
            nameTextFeild.text = "Nick O'Teen"
        }
        
        //setup multi options
        setupOptions(button: normalGoalsButton, options: ["2", "3", "4", "5"], title: "Number of Repetitions (Goal)", userDefaultsKey: DefaultKeys.normalReps)
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
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
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
