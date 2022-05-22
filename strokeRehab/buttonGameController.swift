//
//  buttonGameController.swift
//  strokeRehab
//
//  Created by mobiledev on 22/5/2022.
//

import UIKit

class buttonGameController: UIViewController {

    
    @IBOutlet var buttonA: UIButton!
    
    @IBOutlet var buttonBWidth: NSLayoutConstraint!
    
    @IBOutlet var buttonBHeight: NSLayoutConstraint!
    
    
    
    
    @IBAction func EndPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        buttonA.frame.size = CGSize(width: 100, height: 100)
        
        buttonBWidth.constant
        
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
