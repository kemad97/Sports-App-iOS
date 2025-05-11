//
//  MainViewController.swift
//  SportsApp
//
//  Created by Mustafa Hussain on 10/05/2025.
//

import UIKit

class SportsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var sportsTableView: UITableView!
    private var sportsData: [Sport] = [
        Sport(id: 0, imagePath: "football_card_image", title: "Football"),
        Sport(id: 1, imagePath: "cricket_card_image", title: "Cricket"),
        Sport(id: 2, imagePath: "tennis_card_image", title: "Tennis"),
        Sport(id: 3, imagePath: "basketball_card_image", title: "Basketball")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sportsTableView.dataSource = self
        sportsTableView.delegate = self
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 185
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sportsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(sportsData[indexPath.row].title)
    }

}
