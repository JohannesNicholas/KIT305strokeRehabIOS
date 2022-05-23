//
//  sliderGameController.swift
//  strokeRehab
//
//  Created by mobiledev on 23/5/2022.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class sliderGameController: UIViewController {
    
    
    @IBOutlet var timeBar: UIProgressView!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!

    @IBOutlet var boardView: UIView!
    @IBOutlet var targetBar: UIProgressView!
    @IBOutlet var slider: UISlider!
    
    
    @IBAction func sliderTouchUpInside(_ sender: UISlider) {
        let spots = Float(numberOfNotches + 1)
        let value = Float((sender.value * spots))
        let notch = Int(value)
        
        print("Slid to ", notch)
        record(message: "Slid to \(notch)", correctPress: (notch == nextNotch))
        
        if notch == nextNotch {
            newRound()
        }
    }
    
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let spots = Float(numberOfNotches + 1)
        var value = Float((sender.value * spots))
        value.round()
        sender.value = value / spots
        
        
    }
    
    
    @IBAction func EndPressed(_ sender: Any) {
        endOfGame(stopped: true)
    }
    
    
    
    var numberOfNotches = 3
    var numberOfRounds = 5
    var randomOrder = true
    var freePlay = false
    var timeLimit = 0
    var round = 0
    var nextNotch = 1
    var time = 0
    var timer = Timer()
    var recordData = Record()
    
    
    let db = Firestore.firestore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //rotate the slide to the right angle
        boardView.transform = CGAffineTransform(rotationAngle: (.pi / 2) * -1)
        targetBar.transform = CGAffineTransform(scaleX: 1, y: 5)
        
        
        
        
        //load user defaults
        let defaults = UserDefaults.standard
        numberOfRounds = Int(defaults.string(forKey: DefaultKeys.sliderReps) ?? "5") ?? 0
        timeLimit = Int(defaults.string(forKey: DefaultKeys.sliderTime) ?? "0") ?? 0
        numberOfNotches = Int(defaults.string(forKey: DefaultKeys.sliderNotches) ?? "3") ?? 3
        randomOrder = defaults.object(forKey: DefaultKeys.sliderRandom) as? Bool ?? true
        
        
        
        
        
        //time limit
        self.time = timeLimit
        self.timeBar.progress = 0
        self.timeLabel.text = String(timeLimit)
        if (timeLimit != 0 && !freePlay) {
            self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
                
                
                
                if (self.time == 0) {
                    self.endOfGame(timeOut: true)
                }
                
                self.time -= 1
                
                self.timeBar.progress = Float(self.timeLimit - self.time) / Float(self.timeLimit)
                self.timeLabel.text = String(self.time)
                
            })
        }
        else {
            timeBar.layer.isHidden = true
            timeLabel.layer.isHidden = true
        }
        
        
        
        //setup recordData
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat="yyyy-MM-dd HH:mm:ss"
        recordData.documentID = dateFormatter.string(from: Date())
        recordData.title = "🕹 Slider"
        recordData.messages = []
        if freePlay{
            recordData.reps = nil
        } else {
            recordData.reps = Int32(numberOfRounds)
        }
        recordData.start = Timestamp.init()
        recordData.goals = !freePlay
        recordData.buttonsOrNotches = Int32(numberOfNotches)
        
        newRound()
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        print("dismiss in slider game controller")
        timer.invalidate()
        self.performSegue(withIdentifier: "unwindToOne3", sender: self)
    }
    
    
    //adds a message into the record and stores it in the database
    func record(message: String, correctPress: Bool? = nil) {
        
        print("saving record: ", message)
        
        recordData.messages?.append(
            Message(
                correctPress: correctPress,
                datetime: Timestamp.init(),
                message: message,
                rep: Int32(round)
            )
        )
        
        do {
            try db.collection("Records").document(recordData.documentID ?? "error").setData(from: recordData)
        } catch let error {
            print("Error writing record to Firestore: \(error)")
        }
        
        
        //increment the total correct presses counter
        if (correctPress == true) {
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
                        
                        total.correctButtonPresses = (total.correctButtonPresses ?? 0) + 1
                            do {
                                try self.db.collection("totals").document("totals").setData(from: total)
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
        }
    }
    
    func endOfGame(timeOut: Bool = false, stopped: Bool = false) {
        timer.invalidate()
        var message = ""
        if timeOut {
            message = "⏱ TIME OUT! ⏱"
        }
        else if stopped {
            message = "🚦 STOPPED! 🚦"
        }
        else {
            message = "🏆 COMPLETE! 🏆"
        }
        
        record(message: message)
//        let alert = UIAlertController(title: message, message: "Task is over", preferredStyle: UIAlertController.Style.alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
//            //self.dismiss(animated: true, completion: nil)
//            self.performSegue(withIdentifier: "doneScreen", sender: self)
//
//
//        }))
        
        self.performSegue(withIdentifier: "doneScreen3", sender: self)
        //present(alert, animated: true, completion: nil)
        
        
        
        
    }
    
    func newRound() {
        nextNotch = 1
        round += 1
        
        if (round > numberOfRounds && !freePlay && numberOfRounds != 0){
            endOfGame()
            return
        }
        
        if freePlay || numberOfRounds == 0 {
            scoreLabel.text = "\(round)/∞"
        }
        else {
            scoreLabel.text = "\(round)/\(numberOfRounds)"
        }
        record(message: "Round \(round)")
        
        
        
        slider.value = 0
        if (randomOrder) {
            slider.value = Float(Int.random(in: 0...1))
            
            nextNotch = Int.random(in: 1...numberOfNotches)
            
        }
        
        targetBar.progress = Float(nextNotch) / Float(numberOfNotches + 1)
        
    }
    

    //send the record over
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "doneScreen3"
        {
            if let recordScreen = segue.destination as? RecordUIViewController
            {
                recordScreen.record = recordData
            }
        }
    }

}
