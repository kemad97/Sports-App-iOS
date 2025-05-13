//
//  SportsCellTableViewCell.swift
//  SportsApp
//
//  Created by Mustafa Hussain on 10/05/2025.
//

import UIKit

class SportsCellTableViewCell: UITableViewCell {

    @IBOutlet weak var sportImage: UIImageView!
    @IBOutlet weak var sportTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
