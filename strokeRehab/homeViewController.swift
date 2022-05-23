//
//  homeViewController.swift
//  strokeRehab
//
//  Created by mobiledev on 22/5/2022.
//

import UIKit

class homeViewController: UIViewController {

    
    var freePlay = false
    @IBAction func normalGoalsPressed(_ sender: Any) {
        freePlay = false
    }
    
    @IBAction func sliderGoalsPressed(_ sender: Any) {
        freePlay = false
    }
    
    @IBAction func normalFreePlayPressed(_ sender: Any) {
        freePlay = true
    }
    
    
    @IBAction func normalSliderPressed(_ sender: Any) {
        freePlay = true
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let gameController = segue.destination as? buttonGameController
        {
            gameController.freePlay = freePlay
        }
        
        if let gameController = segue.destination as? sliderGameController
        {
            gameController.freePlay = freePlay
        }
        
    }
    
    
    
    
    
    
    
    
    @IBAction func unwindToOne(_ sender: UIStoryboardSegue) {
        
    }

}
