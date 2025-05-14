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
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Update layout if needed
        teamImg.layer.cornerRadius = teamImg.frame.height / 2
    }
    
    // MARK: - Setup
    private func setupUI() {
        // Cell customization
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        // Configure imageView
        teamImg.contentMode = .scaleAspectFit
        teamImg.clipsToBounds = true
        teamImg.translatesAutoresizingMaskIntoConstraints = false
        teamImg.backgroundColor = .clear
        
        // Configure label
        teamName.textAlignment = .left
        teamName.font = .systemFont(ofSize: 11)
        teamName.numberOfLines = 2
        teamName.textColor = .label
        teamName.adjustsFontSizeToFitWidth = true
        teamName.minimumScaleFactor = 0.8
        teamName.translatesAutoresizingMaskIntoConstraints = false
        
        // Add subtle animation on selection
        let selectedBg = UIView()
        selectedBg.backgroundColor = UIColor.systemGray6
        selectedBackgroundView = selectedBg
    }
    
    // MARK: - Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        teamImg.image = nil
        teamName.text = nil
    }
    
    // MARK: - Configuration
    func configure(with team: Team) {
        teamName.text = team.teamName
        
        // Add loading indicator while image loads
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        teamImg.addSubview(activityIndicator)
        activityIndicator.center = teamImg.center
        activityIndicator.startAnimating()
        
        teamImg.kf.setImage(
            with: URL(string: team.teamLogo ?? ""),
            placeholder: UIImage(named: "placeholder_team"),
            options: [
                .transition(.fade(0.2)),
                .cacheOriginalImage
            ]
        ) { _ in
            activityIndicator.removeFromSuperview()
        }
    }
}
