//
//  UpcomingEventsCell.swift
//  Sports App
//
//  Created by Kerolos on 14/05/2025.
//

import UIKit

class UpcomingEventsCell: UICollectionViewCell {
    @IBOutlet weak var homeName: UILabel!
    @IBOutlet weak var awayName: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var homeImg: UIImageView!
    @IBOutlet weak var awayImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Make team images circular
        [homeImg, awayImg].forEach { imageView in
            imageView?.layer.cornerRadius = (imageView?.frame.height ?? 0) / 2
            imageView?.clipsToBounds = true
        }
        
        // Add rounded corners to cell
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = UIColor.systemGray6
    }
    
    func configure(with fixture: Fixture) {
        homeName.text = fixture.matchHometeamName
        awayName.text = fixture.matchAwayteamName
        date.text = formatDate(fixture.matchDate)
        
        // Load images
        loadImage(from: fixture.teamHomeBadge, into: homeImg)
        loadImage(from: fixture.teamAwayBadge, into: awayImg)
    }
    
    private func formatDate(_ dateString: String) -> String {
        // Convert API date format to readable format
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = inputFormatter.date(from: dateString) else { return dateString }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "MMM d"
        return outputFormatter.string(from: date)
    }
    
    private func loadImage(from urlString: String?, into imageView: UIImageView?) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            imageView?.image = UIImage(named: "placeholder_team")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            
            DispatchQueue.main.async {
                imageView?.image = UIImage(data: data)
            }
        }.resume()
    }
}
