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
    private let emptyStateView = UIView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupEmptyStateView()

        
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
                remoteDataSource: SportsAPIService.shared,
                localDataSource: LeaguesLocalDataSource()
            )
        )
    }
    
    private func setupEmptyStateView() {
            // Configure empty state view
            emptyStateView.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: tableView.bounds.height)
            emptyStateView.backgroundColor = .systemBackground
            
            let imageView = UIImageView(image: UIImage(systemName: "heart.fill"))
            imageView.tintColor = .systemGray3
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            
            let label = UILabel()
            label.text = "No Favorite Leagues Yet"
            label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
            label.textColor = .systemGray2
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            
            let subtitleLabel = UILabel()
            subtitleLabel.text = "Add leagues to your favorites to see them here"
            subtitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            subtitleLabel.textColor = .systemGray3
            subtitleLabel.textAlignment = .center
            subtitleLabel.numberOfLines = 0
            subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
            
            emptyStateView.addSubview(imageView)
            emptyStateView.addSubview(label)
            emptyStateView.addSubview(subtitleLabel)
            
            NSLayoutConstraint.activate([
                imageView.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
                imageView.centerYAnchor.constraint(equalTo: emptyStateView.centerYAnchor, constant: -60),
                imageView.widthAnchor.constraint(equalToConstant: 80),
                imageView.heightAnchor.constraint(equalToConstant: 80),
                
                label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
                label.leadingAnchor.constraint(equalTo: emptyStateView.leadingAnchor, constant: 20),
                label.trailingAnchor.constraint(equalTo: emptyStateView.trailingAnchor, constant: -20),
                
                subtitleLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8),
                subtitleLabel.leadingAnchor.constraint(equalTo: emptyStateView.leadingAnchor, constant: 20),
                subtitleLabel.trailingAnchor.constraint(equalTo: emptyStateView.trailingAnchor, constant: -20)
            ])
            
            // Initially hide the empty state view
            emptyStateView.isHidden = true
            tableView.backgroundView = emptyStateView
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
        
        cell.leagueImage.layer.cornerRadius = cell.leagueImage.layer.frame.width/2
        cell.leagueImage.layer.masksToBounds = true
        
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
        
        if (NetworkMonitor.shared.isConnected){
            let storyboard = UIStoryboard(name: "LeagueDetails", bundle: nil)
            if let leagueDetailsVC = storyboard.instantiateViewController(withIdentifier: "LeagueDetailsViewController") as? LeagueCollectionViewController{
                
                let league = League(
                    leagueKey: Int(leagues[indexPath.row].key),
                    leagueName: leagues[indexPath.row].name ?? "",
                    leagueLogo: leagues[indexPath.row].logo
                )
                
                leagueDetailsVC.league = league
                leagueDetailsVC.sportName = leagues[indexPath.row].sport
                
                navigationController?.pushViewController(leagueDetailsVC, animated: true)
                
            }else{
                print("Failed to instantiate TeamDetailsVC from LeagueCollectionVC.storyboard")
            }
        }
        else {
            let alert = UIAlertController(
                title: "No Internet Connection",
                message: "League details require an internet connection.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true )
        }
    }
    func displayFavorites(leagues: [FavoriteLeagues]) {
        self.leagues = leagues
        self.tableView.reloadData()
        emptyStateView.isHidden = !leagues.isEmpty

    }
    
    func leagueDeleteSuccess() {
        favoritePresenter.getFavoriteLeagues()
    }
    
    func displayError(message: String) {
        print("Error \(message)")
        //display allert to user
    }
}

