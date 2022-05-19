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
    
    var record : Record? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(record?.title ?? "Error, nil value")
        
        recordTitle.title = record?.title ?? "Untitled"
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
