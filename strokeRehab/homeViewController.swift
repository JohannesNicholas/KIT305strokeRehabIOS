//
//  homeViewController.swift
//  strokeRehab
//
//  Created by mobiledev on 22/5/2022.
//

import UIKit

class homeViewController: UIViewController {

    @IBAction func normalGoalsPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "openButtonGame", sender: nil)
    }
    
    @IBAction func sliderGoalsPressed(_ sender: Any) {
    }
    
    @IBAction func normalFreePlayPressed(_ sender: Any) {
    }
    
    
    @IBAction func normalSliderPressed(_ sender: Any) {
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    
    
    @IBAction func unwindToOne(_ sender: UIStoryboardSegue) {
        
    }

}
