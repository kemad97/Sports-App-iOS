import UIKit
import Kingfisher

class LatestEventsCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var homeImg: UIImageView!
    @IBOutlet weak var awayImg: UIImageView!
    @IBOutlet weak var homeName: UILabel!
    @IBOutlet weak var awayName: UILabel!
    @IBOutlet weak var finalScore: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Setup for skeleton
           isSkeletonable = true
           contentView.isSkeletonable = true
           
           // Make each component skeletonable
           homeImg.isSkeletonable = true
           awayImg.isSkeletonable = true
           homeName.isSkeletonable = true
           awayName.isSkeletonable = true
        finalScore.isSkeletonable=true
        
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
            label?.minimumScaleFactor = 0.7
        }
        
        // Score label setup
        finalScore.font = .systemFont(ofSize: 16, weight: .semibold)
        finalScore.textAlignment = .center
        
        // Cell setup
        backgroundColor = .systemBackground
        contentView.backgroundColor = .systemBackground
        
        // Add subtle shadow
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.1
        layer.masksToBounds = false
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        homeImg.image = nil
        awayImg.image = nil
        homeName.text = nil
        awayName.text = nil
        finalScore.text = nil
    }
}
