//
//  UptownTableViewCell.swift
//  yourway
//
//  Created by Riley Dou on 5/24/24.
//

import UIKit

class UptownTableViewCell: UITableViewCell {

    @IBOutlet weak var trainLine: UILabel!
    @IBOutlet weak var trainTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
