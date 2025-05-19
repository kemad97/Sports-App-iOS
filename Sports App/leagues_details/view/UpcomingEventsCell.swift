import UIKit
import Kingfisher

class UpcomingEventsCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var homeImg: UIImageView!
    @IBOutlet weak var awayImg: UIImageView!
    @IBOutlet weak var homeName: UILabel!
    @IBOutlet weak var awayName: UILabel!
    @IBOutlet weak var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Setup for skeleton
        isSkeletonable = true
        contentView.isSkeletonable = true
        
        // Make each component skeletonable
        homeImg.isSkeletonable = true
        awayImg.isSkeletonable = true
        homeName.isSkeletonable = true
        awayName.isSkeletonable=true
        date.isSkeletonable=true
        
        setupUI()
    }
    
    private func setupUI() {
        // ImageViews setup
        [homeImg, awayImg].forEach { imageView in
            imageView?.contentMode = .scaleAspectFit
            imageView?.clipsToBounds = true
            imageView?.backgroundColor = .clear
        }
        
        // Labels setup
        [homeName, awayName].forEach { label in
            label?.font = .systemFont(ofSize: 12)
            label?.textAlignment = .center
            label?.numberOfLines = 2
            label?.adjustsFontSizeToFitWidth = true
        }
        
        // Date label setup
        date.font = .systemFont(ofSize: 14)
        date.textAlignment = .center
        date.textColor = .secondaryLabel
        
        // Cell setup
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        
        // Add subtle shadow
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.1
        layer.masksToBounds = false
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        homeImg.image = UIImage(named: "team_placeholder")
        awayImg.image = UIImage(named: "team_placeholder")
        homeName.text = ""
        awayName.text = ""
        date.text = ""
        
        if sk.isSkeletonActive {
                hideSkeleton()
            }
    }
    
}
