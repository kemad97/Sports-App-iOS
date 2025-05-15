//
//  MainViewController.swift
//  SportsApp
//
//  Created by Mustafa Hussain on 10/05/2025.
//

import UIKit

class SportsViewController: UITableViewController {
    
    private var sportsData: [Sport] = [
        Sport(id: 0, imagePath: "football_card_image", title: "Football"),
        Sport(id: 1, imagePath: "cricket_card_image", title: "Cricket"),
        Sport(id: 2, imagePath: "tennis_card_image", title: "Tennis"),
        Sport(id: 3, imagePath: "basketball_card_image", title: "Basketball")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleLabel = UILabel()
            titleLabel.text = "Sports"
            titleLabel.font = UIFont.boldSystemFont(ofSize: 32)
            titleLabel.textAlignment = .center
            titleLabel.backgroundColor = .systemBackground
            titleLabel.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50)
            
            tableView.tableHeaderView = titleLabel
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sportsData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SportsCellTableViewCell
        
        cell.sportImage?.image = UIImage(named: sportsData[indexPath.row].imagePath)
        cell.sportTitle?.text = sportsData[indexPath.row].title
        
        //make image and title rounded
        cell.sportImage.layer.cornerRadius = 12
        cell.sportImage.layer.masksToBounds = true
        
        cell.sportTitle.layer.cornerRadius = 8
        cell.sportTitle.layer.masksToBounds = true
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Load the view controller from another storyboard
        let storyboard = UIStoryboard(name: "SportsLeagues", bundle: nil)
        if let sportsVC = storyboard.instantiateViewController(withIdentifier: "LeagueTableViewController") as? LeagueTableViewController {
            
            sportsVC.sportName = sportsData[indexPath.row].title
    
            navigationController?.pushViewController(sportsVC, animated: true)
        } else {
            print("Failed to instantiate SportsViewController from SportsLeagues.storyboard")
        }
    }
}
