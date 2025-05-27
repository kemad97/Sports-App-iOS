//  LeagueTableViewCell.swift
//  Sports App
//
//  Created by Mustafa Hussain on 11/05/2025.
//

import UIKit
import Kingfisher
import SkeletonView

class LeagueTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var leagueName: UILabel!
    @IBOutlet weak var leagueImage: UIImageView!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCellAppearance()
        // Configure SkeletonView
        isSkeletonable = true
        leagueImage.isSkeletonable = true
        leagueName.isSkeletonable = true
        showSkeleton()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        leagueImage.image = nil
        leagueImage.kf.cancelDownloadTask()
        leagueName.text = nil
        hideSkeleton()
        print("Cell reused: Skeleton stopped")
    }
    
    // MARK: - Configuration
    func configure(with league: League) {
        print("Configuring cell with league: \(league.leagueName ?? "nil")")
        hideSkeleton() // Stop skeleton before setting content
        
        leagueName.text = league.leagueName
        
        guard let logoURL = league.leagueLogo, let url = URL(string: logoURL) else {
            leagueImage.image = UIImage(named: "leaguePlaceholder")
            hideSkeleton() // Ensure skeleton is stopped for invalid URLs
            print("No valid logo URL, using placeholder")
            return
        }
        
        let processor = DownsamplingImageProcessor(size: leagueImage.bounds.size)
        leagueImage.kf.setImage(
            with: url,
            placeholder: UIImage(named: "leaguePlaceholder"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(0.3)),
                .cacheOriginalImage
            ],
            completionHandler: { [weak self] result in
                switch result {
                case .success:
                    print("Image loaded successfully for \(league.leagueName ?? "unknown")")
                case .failure(let error):
                    print("Image loading failed: \(error)")
                }
                self?.hideSkeleton() // Ensure skeleton stops after image load
            }
        )
    }
    
    // MARK: - Setup
    private func setupCellAppearance() {
        selectionStyle = .none
        leagueImage.layer.cornerRadius = leagueImage.frame.height / 2
        leagueImage.layer.borderWidth = 1.5
        leagueImage.layer.borderColor = UIColor.quaternarySystemFill.cgColor
        leagueImage.clipsToBounds = true
        leagueImage.contentMode = .scaleAspectFit
        leagueImage.backgroundColor = .tertiarySystemBackground
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
    
    // MARK: - SkeletonView
    private func showSkeleton() {
        print("Starting skeleton effect")
        [leagueImage, leagueName].forEach { $0.showAnimatedGradientSkeleton() }
    }
    
    private func hideSkeleton() {
        print("Stopping skeleton effect")
        [leagueImage, leagueName].forEach { $0.hideSkeleton() }
    }
}
