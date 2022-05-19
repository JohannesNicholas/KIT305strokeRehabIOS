//
//  RecordUIViewController.swift
//  strokeRehab
//
//  Created by mobiledev on 19/5/2022.
//

import UIKit

class RecordUIViewController: UIViewController {
    @IBOutlet var recordTitle: UINavigationItem!
    
    var record : Record? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(record?.title ?? "Error, nil value")
        
        recordTitle.title = record?.title ?? "Untitled"
    }
    

    
    
    

}
