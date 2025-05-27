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
    
    // MARK: - Properties
    private var skeletonTimer: Timer?
    private var pendingLeagueName: String?
    private var pendingImage: UIImage?
    private var isSkeletonScheduledToStop: Bool = false
    
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
        pendingLeagueName = nil
        pendingImage = nil
        isSkeletonScheduledToStop = false
        invalidateSkeletonTimer()
        DispatchQueue.main.async { [weak self] in
            self?.hideSkeleton()
            print("Cell reused: Skeleton stopped at \(Date())")
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
      
    }
    
    // MARK: - Configuration
    func configure(with league: League) {
        print("Configuring cell with league: \(league.leagueName ?? "nil") at \(Date())")
        
        // Store content to apply after 1-second skeleton
        pendingLeagueName = league.leagueName
        
        // Start 1-second skeleton timer
        startSkeletonTimer(for: league)
        
        guard let logoURL = league.leagueLogo, let url = URL(string: logoURL) else {
            pendingImage = UIImage(named: "leaguePlaceholder")
            print("No valid logo URL, using placeholder for \(league.leagueName ?? "nil") at \(Date())")
            return
        }
        
        print("Loading image from: \(logoURL)")
        let processor = DownsamplingImageProcessor(size: leagueImage.bounds.size)
        leagueImage.kf.setImage(
            with: url,
            placeholder: nil, // No placeholder during skeleton
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(0.3)),
                .cacheOriginalImage
            ],
            completionHandler: { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let value):
                        self?.pendingImage = value.image
                        print("Image loaded successfully for \(league.leagueName ?? "unknown") at \(Date())")
                    case .failure(let error):
                        self?.pendingImage = UIImage(named: "leaguePlaceholder")
                        print("Image loading failed for \(league.leagueName ?? "unknown"): \(error) at \(Date())")
                    }
                }
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
        print("Starting skeleton effect at \(Date())")
        [leagueImage, leagueName].forEach {
            $0.showAnimatedGradientSkeleton(
                usingGradient: .init(baseColor: .systemGray5, secondaryColor: .systemGray3),
                transition: .crossDissolve(0.25)
            )
        }
    }
    
    private func hideSkeleton() {
        guard !isSkeletonScheduledToStop else {
            print("Skeleton already scheduled to stop at \(Date())")
            return
        }
        isSkeletonScheduledToStop = true
        print("Stopping skeleton effect at \(Date())")
        [leagueImage, leagueName].forEach { $0.hideSkeleton(transition: .crossDissolve(0.25)) }
        // Apply pending content
        leagueName.text = pendingLeagueName
        leagueImage.image = pendingImage
        setNeedsLayout() // Force UI refresh
    }
    
    // MARK: - Skeleton Timer
    private func startSkeletonTimer(for league: League) {
        invalidateSkeletonTimer()
        skeletonTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { [weak self] _ in
            DispatchQueue.main.async {
                self?.hideSkeleton()
                print("Skeleton stopped after 1-second timer for \(league.leagueName ?? "nil") at \(Date())")
            }
            self?.skeletonTimer = nil
        }
    }
    
    private func invalidateSkeletonTimer() {
        skeletonTimer?.invalidate()
        skeletonTimer = nil
    }
}
