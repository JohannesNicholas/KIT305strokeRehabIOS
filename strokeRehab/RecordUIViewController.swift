//
//  RecordUIViewController.swift
//  strokeRehab
//
//  Created by mobiledev on 19/5/2022.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class RecordUIViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var recordTitle: UINavigationItem!
    
    @IBOutlet weak var timeAndDateLabel: UILabel!
    @IBOutlet weak var repsInSecondsLabel: UILabel!
    @IBOutlet weak var correctPressesLabel: UILabel!
    
    
    var imagePicker = UIImagePickerController()
    @IBOutlet var imageView: UIImageView!
    @IBAction func cameraButtonPressed(_ sender: UIBarButtonItem) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
                    print("Button capture")

                    imagePicker.delegate = self
                    imagePicker.sourceType = .savedPhotosAlbum
                    imagePicker.allowsEditing = false

                    present(imagePicker, animated: true, completion: nil)
                }
    
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("done selecting!")
        print(info)
        guard let image = info[.originalImage] as? UIImage else { return }

        imageView.image = image
        
        
        let success = saveImage(image: image)
        print("save image success:", success)
        
        
        imagePicker.dismiss(animated: true)
    }
    
    
    func saveImage(image: UIImage) -> Bool {
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
            return false
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return false
        }
        do {
            try data.write(to: directory.appendingPathComponent(record?.documentID ?? "")!)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    func getSavedImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
    }
    
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    
    
    
    @IBAction func ShareButtonPressed(_ sender: UIBarButtonItem) {
        
        var text = "message, timestamp, correct press\n"
        
        for message in record?.messages ?? [] {
            var line = (message.message ?? "title") + ","
            line += (message.datetime?.description ?? "unknown") + ","
            line += (message.correctPress == nil ? "nil" : String(message.correctPress ?? false)) + ","
            text += line + "\n"
        }
        
        
        
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    
    @IBAction func deleteButtonPressed(_ sender: UIBarButtonItem) {
        let deleteAlert = UIAlertController(title: "Delete?", message: "Are you sure you want to permanently delete this record?", preferredStyle: UIAlertController.Style.alert)
        
        deleteAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            print("OK button pressed")
            
            let db = Firestore.firestore()
            print("\nINITIALIZED FIRESTORE APP for record deletion \(db.app.name)\n")
            
            db.collection("Records").document(self.record?.documentID ?? "").delete()
            
            let docRef = db.collection("totals").document("totals")

            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let conversionResult = Result
                    {
                        try document.data(as: Totals.self)
                    }

                    //check if conversionResult is success or failure (i.e. was an exception/error thrown?
                    switch conversionResult
                    {
                        //no problems (but could still be nil)
                        case .success(var total):
                            print("loaded!")
                        
                            var correctButtonPresses = 0
                            for message in self.record?.messages ?? [] {
                                if (message.correctPress == true){
                                    correctButtonPresses += 1
                                }
                            }
                        
                        total.correctButtonPresses = (total.correctButtonPresses ?? 0) - Int32(correctButtonPresses)
                            do {
                                try db.collection("totals").document("totals").setData(from: total)
                            } catch let error {
                                print("Error writing city to Firestore: \(error)")
                            }
                        
                        
                            
                            
                        case .failure(let error):
                            // A `Movie` value could not be initialized from the DocumentSnapshot.
                            print("Error decoding data: \(error)")
                    }
                } else {
                    print("Document does not exist")
                }
            }
            
            self.dismiss(animated: true, completion: nil)
        }))

        deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
              
        }))
        
        present(deleteAlert, animated: true, completion: nil)
    }
    
    
    var record : Record? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(record?.title ?? "Error, nil value")
        
        recordTitle.title = record?.title ?? "Untitled"
        
        //load the image
        if let image = getSavedImage(named: record?.documentID ?? "") {
            imageView.image = image
        }
        
        
        
        
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
                let timeToComplete = Float(lastMessage.datetime!.dateValue().timeIntervalSince(record?.start?.dateValue() ?? Date()))
                text += String(format: " %.3f seconds", timeToComplete)
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
