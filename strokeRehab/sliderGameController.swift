//
//  sliderGameController.swift
//  strokeRehab
//
//  Created by mobiledev on 23/5/2022.
//

import UIKit

class sliderGameController: UIViewController {
    
    
    @IBOutlet var timeBar: UIProgressView!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!

    @IBOutlet var boardView: UIView!
    @IBOutlet var targetBar: UIProgressView!
    
    @IBAction func EndPressed(_ sender: Any) {
        //endOfGame(stopped: true)
    }
    
    
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
