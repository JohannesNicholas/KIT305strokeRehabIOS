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

    @IBOutlet var tableView: UITableView!
    
    
    var records: [Record] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        let db = Firestore.firestore()
        print("\nINITIALIZED FIRESTORE APP \(db.app.name)\n")
        
        db.collection("Records").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
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


}


extension HistoryController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Youo tapped ", indexPath.row)
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
        }
        else {
            let record = self.records[indexPath.row]
            cell.left.text = record.title ?? "Untitled"
            cell.middle.text = record.start?.dateValue().description
            cell.right.text = String(describing: record.reps)
        }
        
        
        return cell
    }
}

