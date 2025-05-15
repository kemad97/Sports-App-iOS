//
//  FavoriteScreenTableViewController.swift
//  Sports App
//
//  Created by Mustafa Hussain on 14/05/2025.
//

import UIKit

class FavoriteScreenTableViewController: UITableViewController, FavoriteView {

    private var leagues: [FavoriteLeagues] = []
    private var favoritePresenter: FavoritePresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorite leagues"

        favoritePresenter = FavoritePresenter(
            view: self,
            repo: SportsReposatory(
                remoteDataSource: SportsAPIService(),
                localDataSource: LeaguesLocalDataSource()
            )
        )
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

        cell.leagueImage.image = UIImage(named: "team_placeholder")
        cell.leagueName.text = "league name"

        return cell
    }

    func displayFavorites(leagues: [FavoriteLeagues]) {
        self.leagues = leagues
        self.tableView.reloadData()
    }

    func displayError(message: String) {
        print("Error \(message)")
        //display allert to user
    }
}
