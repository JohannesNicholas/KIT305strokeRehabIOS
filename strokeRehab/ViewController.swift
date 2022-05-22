//
//  ViewController.swift
//  strokeRehab
//
//  Created by mobiledev on 12/5/2022.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let db = Firestore.firestore()
        print("\nINITIALIZED FIRESTORE APP \(db.app.name)\n")    }


    let test = Array((1...50))
    
}

