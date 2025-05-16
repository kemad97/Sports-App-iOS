//
//  FavoriteScreenTableViewController.swift
//  Sports App
//
//  Created by Mustafa Hussain on 14/05/2025.
//

import UIKit
import Kingfisher

class FavoriteScreenTableViewController: UITableViewController, FavoriteView {
    

    private var leagues: [FavoriteLeagues] = []
    private var favoritePresenter: FavoritePresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleLabel = UILabel()
            titleLabel.text = "Favorite Leagues"
            titleLabel.font = UIFont.boldSystemFont(ofSize: 32)
            titleLabel.textAlignment = .center
            titleLabel.backgroundColor = .systemBackground
            titleLabel.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50)
            
            tableView.tableHeaderView = titleLabel
        
        favoritePresenter = FavoritePresenter(
            view: self,
            repo: SportsRepository(
                remoteDataSource: SportsAPIService(),
                localDataSource: LeaguesLocalDataSource()
            )
        )
    }

    override func viewWillAppear(_ animated: Bool) {
        favoritePresenter.getFavoriteLeagues()
    }
    
    override func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return 100
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return leagues.count
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell =
            tableView.dequeueReusableCell(
                withIdentifier: "cell",
                for: indexPath
            ) as! FavorteLeagueTableViewCell

        cell.leagueImage.kf.setImage(with: URL(string: leagues[indexPath.row].logo ?? ""),
                                     placeholder: UIImage(named: "leaguePlaceholder"))
        cell.leagueName.text = leagues[indexPath.row].name

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Delete Favorite League!", message: "Are you sure you want to delete this favorite league?", preferredStyle: .alert)
        
        // OK action
        let okAction = UIAlertAction(title: "OK", style: .default) {[weak self] _ in
            guard let leagues = self?.leagues else { return }
            
            self?.favoritePresenter.deleteFavoriteLeague(favoriteLeague: leagues[indexPath.row])
        }
        
        // Cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //if there an internet connection
        //navigate to league details screen
        //other wise show no internet connection allert
        let storyboard = UIStoryboard(name: "LeagueDetails", bundle: nil)
        if let leagueDetailsVC = storyboard.instantiateViewController(withIdentifier: "LeagueDetailsViewController") as? LeagueCollectionViewController{
            
            let league = League(
                leagueKey: Int(leagues[indexPath.row].key),
                leagueName: leagues[indexPath.row].name ?? "",
                leagueLogo: leagues[indexPath.row].logo
            )
            
            leagueDetailsVC.league = league
            
            navigationController?.pushViewController(leagueDetailsVC, animated: true)
            
        }else{
            print("Failed to instantiate TeamDetailsVC from LeagueCollectionVC.storyboard")
        }
    }

    func displayFavorites(leagues: [FavoriteLeagues]) {
        self.leagues = leagues
        self.tableView.reloadData()
    }
    
    func leagueDeleteSuccess() {
        favoritePresenter.getFavoriteLeagues()
    }

    func displayError(message: String) {
        print("Error \(message)")
        //display allert to user
    }
}
