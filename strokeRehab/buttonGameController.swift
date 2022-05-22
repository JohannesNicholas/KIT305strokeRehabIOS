//
//  buttonGameController.swift
//  strokeRehab
//
//  Created by mobiledev on 22/5/2022.
//

import UIKit

import Firebase
import FirebaseFirestoreSwift

class buttonGameController: UIViewController {

    @IBOutlet var timeBar: UIProgressView!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    
    @IBOutlet var buttonA: UIButton!
    @IBOutlet var buttonB: UIButton!
    @IBOutlet var buttonC: UIButton!
    @IBOutlet var buttonD: UIButton!
    @IBOutlet var buttonE: UIButton!
    var buttonUIs: [UIButton] = []
    
    
    @IBOutlet var buttonAWidth: NSLayoutConstraint!
    @IBOutlet var buttonAHeight: NSLayoutConstraint!
    @IBOutlet var buttonBWidth: NSLayoutConstraint!
    @IBOutlet var buttonBHeight: NSLayoutConstraint!
    @IBOutlet var buttonCWidth: NSLayoutConstraint!
    @IBOutlet var buttonCHeight: NSLayoutConstraint!
    @IBOutlet var buttonDWidth: NSLayoutConstraint!
    @IBOutlet var buttonDHeight: NSLayoutConstraint!
    @IBOutlet var buttonEWidth: NSLayoutConstraint!
    @IBOutlet var buttonEHeight: NSLayoutConstraint!
    var buttonSizeConstraints : [NSLayoutConstraint] = []
    
    @IBAction func buttonApressed(_ sender: Any) {
        buttonPressed(1)
    }
    @IBAction func buttonBpressed(_ sender: Any) {
        buttonPressed(2)
    }
    @IBAction func buttonCpressed(_ sender: Any) {
        buttonPressed(3)
    }
    @IBAction func buttonDpressed(_ sender: Any) {
        buttonPressed(4)
    }
    @IBAction func buttonEpressed(_ sender: Any) {
        buttonPressed(5)
    }
    
    
    @IBAction func EndPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    var numberOfButtons = 3
    var numberOfRounds = 5
    var randomOrder = true
    var highlightNextButton = true
    var freePlay = false
    var timeLimit = 0
    var round = 0
    var nextNumber = 1
    var time = 0
    var timer = Timer()
    var recordData = Record()
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        buttonUIs = [buttonA, buttonB, buttonC, buttonD, buttonE]
        buttonSizeConstraints = [
            buttonAWidth,
            buttonAHeight,
            buttonBWidth,
            buttonBHeight,
            buttonCWidth,
            buttonCHeight,
            buttonDWidth,
            buttonDHeight,
            buttonEWidth,
            buttonEHeight]
        
        
        
        //load user defaults
        let defaults = UserDefaults.standard
        let sizeKey = defaults.string(forKey: DefaultKeys.normalSize) ?? "M"
        numberOfRounds = Int(defaults.string(forKey: DefaultKeys.normalReps) ?? "5") ?? 0
        timeLimit = Int(defaults.string(forKey: DefaultKeys.normalTime) ?? "0") ?? 0
        numberOfButtons = Int(defaults.string(forKey: DefaultKeys.normalNumButtons) ?? "3") ?? 3
        randomOrder = defaults.object(forKey: DefaultKeys.normalRandom) as? Bool ?? true
        highlightNextButton = defaults.object(forKey: DefaultKeys.normalHighlightNext) as? Bool ?? true
        
        
        //set sizes of the buttons
        let sizes = [
            "S" : 50,
            "M" : 75,
            "L" : 100,
            "XL" : 125
        ]
        let size = sizes[sizeKey] ?? 500
        for constraint in buttonSizeConstraints {
            constraint.constant = CGFloat(size)
        }
        for button in buttonUIs {
            button.layer.cornerRadius = CGFloat(size/2)
            button.layer.masksToBounds = true
        }
        
        
        //time limit
        if (timeLimit != 0) {
            self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
                
                
                
                if (self.time == 0) {
                    endOfGame(timeout: true)
                }
                
                self.time -= 1
                
                self.timeBar.progress = Float(self.timeLimit - self.time) / Float(self.timeLimit)
                self.timeLabel.text = String(self.timeLimit - self.time)
                
            })
        }
        else {
            timeBar.layer.isHidden = true
            timeLabel.layer.isHidden = true
        }
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat="yyyy-MM-dd HH:mm:ss"
        recordData.documentID = dateFormatter.string(from: Date())
        recordData.title = "🌐 Normal"
        recordData.messages = []
        if freePlay{
            recordData.reps = nil
        } else {
            recordData.reps = Int32(numberOfRounds)
        }
        recordData.start = Timestamp.init()
        recordData.goals = !freePlay
        
        newRound()
        
        
        
        do {
            try db.collection("Records").document(recordData.documentID ?? "error").setData(from: recordData)
        } catch let error {
            print("Error writing record to Firestore: \(error)")
        }
    }
    
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        timer.invalidate()
        super.dismiss(animated: flag, completion: completion)
    }
    
    
    //called when a button is pressed, passed the number of the button
    func buttonPressed(number: Int) {
        record(message: "\(number) Pressed", correctPress: (number == nextNumber))
        
        if number == nextNumber {
            
            if (nextNumber == numberOfButtons) {
                newRound()
            }
            else {
                nextNumber += 1
            }
         
            highlightNextNum()
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
    
     // Pass the selected object to the new view controller.
    }
    */

}

