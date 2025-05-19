import UIKit
import Kingfisher

class TeamsCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var teamImg: UIImageView!
    @IBOutlet weak var teamName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Setup for skeleton
           isSkeletonable = true
           contentView.isSkeletonable = true
           
        teamImg.isSkeletonable = true
        teamName.isSkeletonable = true
        
        setupUI()
    }
    
    private func setupUI() {
        // ImageView setup
        teamImg.contentMode = .scaleAspectFit
        teamImg.clipsToBounds = true
        teamImg.backgroundColor = .clear
        
        // Label setup
        teamName.font = .systemFont(ofSize: 11)
        teamName.textAlignment = .center
        teamName.numberOfLines = 2
        teamName.adjustsFontSizeToFitWidth = true
        teamName.minimumScaleFactor = 0.8
        
        // Cell setup
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        teamImg.image = UIImage(named: "team_placeholder")
        teamName.text = ""
        
        if sk.isSkeletonActive {
                hideSkeleton()
            }
    }
    
    // MARK: - Configuration
    func configure(with team: Team) {
        teamName.text = team.teamName
        
        // Add loading indicator
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
