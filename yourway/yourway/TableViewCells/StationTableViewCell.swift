//
//  StationTableViewCell.swift
//  yourway
//
//  Created by Riley Dou on 5/28/24.
//

import UIKit

class StationTableViewCell: UITableViewCell {

    @IBOutlet weak var stationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
