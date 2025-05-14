//
//  TeamsCell.swift
//  Sports App
//
//  Created by Kerolos on 14/05/2025.
//

import UIKit


class TeamsCell: UICollectionViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var teamImg: UIImageView!
    @IBOutlet weak var teamName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // UI Customization
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.2
        layer.masksToBounds = false
        
        // Make team image circular
        teamImg.layer.cornerRadius = teamImg.frame.height / 2
        teamImg.clipsToBounds = true
    }
}
