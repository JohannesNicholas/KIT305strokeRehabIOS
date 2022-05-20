//
//  RecordUIViewController.swift
//  strokeRehab
//
//  Created by mobiledev on 19/5/2022.
//

import UIKit

class RecordUIViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var recordTitle: UINavigationItem!
    
    @IBOutlet weak var timeAndDateLabel: UILabel!
    @IBOutlet weak var repsInSecondsLabel: UILabel!
    @IBOutlet weak var correctPressesLabel: UILabel!
    
    var record : Record? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(record?.title ?? "Error, nil value")
        
        recordTitle.title = record?.title ?? "Untitled"
        
        
        
        //date formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat="dd MMM yyyy - hh:mm:ss a"
        timeAndDateLabel.text = dateFormatter.string(from: record?.start?.dateValue() ?? Date())
        
        
        
        //seconds in rep
        if let lastMessage = record?.messages?.last {
            var text = ""
            if (lastMessage.rep == nil) {
                text += "?"
            }
            else {
                text += String(lastMessage.rep! - 1)
            }
            
            text += " repetitions in "
            
            if lastMessage.datetime == nil || record?.start == nil {
                text += "⏰?"
            }
            else {
                let timeToComplete = Float(lastMessage.datetime!.dateValue().timeIntervalSince1970) - Float((record?.start!.dateValue().timeIntervalSince1970)!)
                text += String(format: " %.2f seconds", timeToComplete)
            }
            
            repsInSecondsLabel.text = text
        }
        
        
        
        
        
        
        
        
        //correct button presse
        var correctButtonPresses = 0
        for message in record?.messages ?? [] {
            if (message.correctPress == true){
                correctButtonPresses += 1
            }
        }
        correctPressesLabel.text = "\(correctButtonPresses) correct presses"
        
        
    }
    

    
    
    
    
    

}

extension RecordUIViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped ", indexPath.row)
        
        
        
    }
    
}
extension RecordUIViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.record?.messages?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recordMessageCell", for: indexPath) as! RecordMessageViewCell
        
        
        
        if let message = self.record?.messages?[indexPath.row] {
            cell.messageLabel.text = message.message ?? ""
            
            
            let time = message.datetime?.dateValue() ?? Date()
            let attemptStart = record?.start?.dateValue() ?? Date()
            let difference = Float(time.timeIntervalSince(attemptStart))
            cell.secondsLabel.text = String(format: "+ %.1f s", difference)
            
            if let success = message.correctPress {
                if success {
                    cell.iconLabel.text = "✅"
                }
                else {
                    cell.iconLabel.text = "❌"
                }
            }
            else {
                cell.iconLabel.text = ""
            }
        }
        
        
        
        
        
        return cell
    }
}
