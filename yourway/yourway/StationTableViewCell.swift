//
//  StationTableViewCell.swift
//  yourway
//
//  Created by Riley Dou on 4/23/24.
//

import UIKit

class StationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
