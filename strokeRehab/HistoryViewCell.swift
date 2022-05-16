//
//  HistoryViewCell.swift
//  strokeRehab
//
//  Created by mobiledev on 16/5/2022.
//

import UIKit

class HistoryViewCell: UITableViewCell {
    @IBOutlet weak var left: UILabel!
    @IBOutlet weak var right: UILabel!
    @IBOutlet weak var middle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
