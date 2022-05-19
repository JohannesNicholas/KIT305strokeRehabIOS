//
//  RecordMessageViewCell.swift
//  strokeRehab
//
//  Created by mobiledev on 19/5/2022.
//

import UIKit

class RecordMessageViewCell: UITableViewCell {

    @IBOutlet var iconLabel: UILabel!
    @IBOutlet var secondsLabel: UILabel!
    @IBOutlet var messageLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
