//
//  LeagueTableViewController.swift
//  Sports App
//
//  Created by Mustafa Hussain on 11/05/2025.
//

import UIKit
import Kingfisher

class LeagueTableViewController: UITableViewController, LeaguesView {
    
    var sportName : String!
    var leaguesList: [League] = []
    private var leaguesPresenter : LeaguesPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "\(sportName!) Leagues"
        leaguesPresenter = LeaguesPresenter(view: self)
        leaguesPresenter.getLeagues(sport: sportName.lowercased())
    }

    // MARK: - Table view data source

    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return leaguesList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LeagueTableViewCell
        
        cell.leagueName.text = leaguesList[indexPath.row].leagueName
        cell.leagueImage.kf.setImage(with: URL(string: leaguesList[indexPath.row].leagueLogo ?? ""), placeholder: UIImage(named: "leaguePlaceholder"))
        
        
        cell.leagueImage.layer.cornerRadius = cell.leagueImage.layer.frame.width/2
        cell.leagueImage.layer.masksToBounds = true
        

        return cell
    }
    
    

    func displayLeagues(_ leagues: [League]) {
        leaguesList = leagues
        tableView.reloadData()
    }
    
    func displayError(_ message: String) {
        showNetworkError()
    }
    
    func showNetworkError() {
          DispatchQueue.main.async {
              let alert = UIAlertController(
                  title: "No Internet Connection",
                  message: "Please check your connection and try again.",
                  preferredStyle: .alert
              )
              alert.addAction(UIAlertAction(title: "OK", style: .default))
              self.present(alert, animated: true)
          }
      }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (NetworkMonitor.shared.isConnected){
            // Load the view controller from another storyboard
            let storyboard = UIStoryboard(name: "LeagueDetails", bundle: nil)
            if let leagueDetailsVC = storyboard.instantiateViewController(withIdentifier: "LeagueDetailsViewController") as? LeagueCollectionViewController {
                
                leagueDetailsVC.league = leaguesList[indexPath.row]
                
                leagueDetailsVC.sportName=sportName
                
                navigationController?.pushViewController(leagueDetailsVC, animated: true)
            } else {
                print("Failed to instantiate LeagueDetailsViewController from LeagueDetailsViewController.storyboard")
            }
        }
        else {
            showNetworkError()
        }
        
    }
    
    
    
}
