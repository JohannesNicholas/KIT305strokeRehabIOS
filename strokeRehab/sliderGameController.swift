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
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let spots = Float(numberOfNotches + 1)
        var value = Float((sender.value * spots))
        value.round()
        sender.value = value / spots
    }
    
    
    @IBAction func EndPressed(_ sender: Any) {
        //endOfGame(stopped: true)
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
