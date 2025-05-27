//
//  LeagueTableViewCell.swift
//  Sports App
//
//  Created by Mustafa Hussain on 11/05/2025.
//


import UIKit
import Kingfisher

class LeagueTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var leagueName: UILabel!
    @IBOutlet weak var leagueImage: UIImageView!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCellAppearance()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        leagueImage.image = nil
        leagueImage.kf.cancelDownloadTask() // Cancel pending image downloads
        leagueName.text = nil
    }
    
    // MARK: - Configuration
    func configure(with league: League) {
        leagueName.text = league.leagueName
        
        // Use Kingfisher for efficient image loading with cache
        let processor = DownsamplingImageProcessor(size: leagueImage.bounds.size)
        leagueImage.kf.setImage(
            with: URL(string: league.leagueLogo ?? ""),
            placeholder: UIImage(named: "leaguePlaceholder"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(0.3)),
                .cacheOriginalImage
            ]
        )
    }
    
    // MARK: - Setup
    private func setupCellAppearance() {
        selectionStyle = .none
        
        
        // League Image
        leagueImage.layer.cornerRadius = leagueImage.frame.height / 2
        leagueImage.layer.borderWidth = 1.5
        leagueImage.layer.borderColor = UIColor.quaternarySystemFill.cgColor
        leagueImage.clipsToBounds = true
        leagueImage.contentMode = .scaleAspectFit
        leagueImage.backgroundColor = .tertiarySystemBackground
        
        // League Name
        leagueName.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        leagueName.textColor = .label
        leagueName.numberOfLines = 2
        leagueName.adjustsFontSizeToFitWidth = true
        leagueName.minimumScaleFactor = 0.8
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
          super.setHighlighted(highlighted, animated: animated)
          
          UIView.animate(withDuration: 0.3,
                        delay: 0,
                        usingSpringWithDamping: 0.8,
                        initialSpringVelocity: 0.5,
                        options: [.allowUserInteraction, .curveEaseOut],
                        animations: {
              self.transform = highlighted ? CGAffineTransform(scaleX: 0.96, y: 0.96) : .identity
              self.alpha = highlighted ? 0.9 : 1.0
          })
      }
    
  
}
