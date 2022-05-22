//
//  buttonGameController.swift
//  strokeRehab
//
//  Created by mobiledev on 22/5/2022.
//

import UIKit

class buttonGameController: UIViewController {

    
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
        
        
        
        
        // Do any additional setup after loading the view.
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

