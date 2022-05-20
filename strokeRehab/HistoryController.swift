//
//  historyController.swift
//  strokeRehab
//
//  Created by mobiledev on 16/5/2022.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift


class HistoryController: UIViewController {

    var snapshotListener: ListenerRegistration? = nil
    

    
    @IBOutlet var tableView: UITableView!
    
    
    
    
    @IBOutlet var leftFilterOptions: UIDeselectableSegmentedControl!
    
    @IBOutlet var rightFilterOptions: UIDeselectableSegmentedControl!
    
    @IBAction func leftFilterOptionsValueChanged(_ sender: Any) {
        setupRecordsListner()
    }
    
    @IBAction func rightOptionsValueChanged(_ sender: Any) {
        setupRecordsListner()
    }
    
    
    
    
    @IBAction func shareButton(_ sender: Any) {
        var text = "title, start, end, repetition count, presses count\n"
        
        for record in records {
            var line = (record.title ?? "title") + ","
            line += (record.start?.description ?? "unknown") + ","
            line += (record.messages?.last?.datetime?.description ?? "unknown") + ","
            line += (record.reps == nil ? "∞" : String(record.reps ?? 0)) + ","
            line += (record.buttonsOrNotches == nil ? "?" : String(record.buttonsOrNotches ?? 0)) + ","
            text += line + "\n"
        }
        
        
        
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        self.present(activityViewController, animated: true, completion: nil)
        
        
    }
    
    var records: [Record] = []
    var selectedRowID = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        
        leftFilterOptions.selectedSegmentTintColor = UIColor.tintColor
        
        rightFilterOptions.selectedSegmentTintColor = UIColor.tintColor
        
        
        setupRecordsListner()
        
    }
    
    
    
    func setupRecordsListner() {
        
        if let sl = snapshotListener {
            sl.remove()
        }
        
        
        let db = Firestore.firestore()
        print("\nINITIALIZED FIRESTORE APP \(db.app.name)\n")
        
        
        
        
        var query: Query = db.collection("Records")
        
        
        //filter options
        if leftFilterOptions.selectedSegmentIndex == 0 {
            query = query.whereField("title", isEqualTo: "🌐 Normal")
        }
        if leftFilterOptions.selectedSegmentIndex == 1 {
            query = query.whereField("title", isEqualTo: "🕹️ Slider")
        }
        if rightFilterOptions.selectedSegmentIndex == 0 {
            query = query.whereField("goals", isEqualTo: false)
        }
        if rightFilterOptions.selectedSegmentIndex == 1 {
            query = query.whereField("goals", isEqualTo: true)
        }
        
        
        
        
        snapshotListener = query.addSnapshotListener() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    
                    self.records = []
                    
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        
                        let conversionResult = Result
                        {
                            try document.data(as: Record.self)
                        }

                        //check if conversionResult is success or failure (i.e. was an exception/error thrown?
                        switch conversionResult
                        {
                            //no problems (but could still be nil)
                            case .success(let record):
                                print("Movie: \(record)")
                            self.records.insert(record, at: 0)
                                
                            case .failure(let error):
                                // A `Movie` value could not be initialized from the DocumentSnapshot.
                                print("Error decoding movie: \(error)")
                        }
                    }
                    self.tableView.reloadData()
                }
        }
    }
    
    
    
    //send the record over
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToRecordScreen"
        {
            if let recordScreen = segue.destination as? RecordUIViewController
            {
                recordScreen.record = records[selectedRowID]
            }
        }
    }


}


extension HistoryController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped ", indexPath.row)
        selectedRowID = indexPath.row
        
        self.performSegue(withIdentifier: "goToRecordScreen", sender: nil)
        
        
    }
    
}
extension HistoryController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (records.isEmpty){
            return 1
        }
        return self.records.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HistoryViewCell
        
        if (self.records.isEmpty){
            cell.left.text = "Loading..."
            cell.middle.text = "Loading..."
            cell.right.text = "Loading..."
        }
        else {
            let record = self.records[indexPath.row]
            cell.left.text = record.title ?? "Untitled"
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat="d MMM ha"
            let startDate : Date = record.start?.dateValue() ?? Date()
            cell.middle.text = dateFormatter.string(from: startDate)
            
            cell.right.text = "\(record.reps == nil ? "∞" : String(record.reps ?? 0)) x \(record.buttonsOrNotches == nil ? "?" : String(record.buttonsOrNotches ?? 0))"
        }
        
        
        return cell
    }
}

