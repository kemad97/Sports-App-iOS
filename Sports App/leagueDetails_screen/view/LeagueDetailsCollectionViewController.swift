//
//  LeagueDetailsCollectionViewController.swift
//  Sports App
//
//  Created by Kerolos on 14/05/2025.
//

import UIKit

private let reuseIdentifier = "Cell"

class LeagueDetailsViewController: UIViewController  {
    @IBOutlet weak var upcomingEventsCollectionView: UICollectionView!
    
    @IBOutlet weak var latestEventsCollectionView: UICollectionView!
    
    @IBOutlet weak var teamsCollectionView: UICollectionView!
    
    var league: League!
    private var upcomingFixtures: [Fixture] = []
    private var latestFixtures: [Fixture] = []
    private var teams: [Team] = []
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        fetchData()
        
        
    }
    private func setupUI() {
        title = league?.leagueName ?? "League Details"
        
        // Setup activity indicator
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        
        // Configure collection views
        configureCollectionViews()
        
        // Add favorite button
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "heart"),
            style: .plain,
            target: self,
            action: #selector(toggleFavorite)
        )
    }
    
    private func configureCollectionViews() {
        // Setup delegates and data sources
        upcomingEventsCollectionView.delegate = self
        upcomingEventsCollectionView.dataSource = self
        
        latestEventsCollectionView.delegate = self
        latestEventsCollectionView.dataSource = self
        
        teamsCollectionView.delegate = self
        teamsCollectionView.dataSource = self
        
        // Important: Disable scrolling for Latest Events collection
        latestEventsCollectionView.isScrollEnabled = false
    }
    
    // MARK: - Data Fetching
    private func fetchData() {
        guard league != nil else { return }
        
        activityIndicator.startAnimating()
        
        let group = DispatchGroup()
        
        // 1. Fetch upcoming fixtures
        group.enter()
        fetchUpcomingFixtures { group.leave() }
        
        // 2. Fetch latest fixtures
        group.enter()
        fetchLatestFixtures { group.leave() }
        
        // 3. Fetch teams
        group.enter()
        fetchTeams { group.leave() }
        
        group.notify(queue: .main) { [weak self] in
            self?.activityIndicator.stopAnimating()
            self?.updateUI()
        }
    }
    
    private func fetchUpcomingFixtures(completion: @escaping () -> Void) {
        guard let league = league else {
            completion()
            return
        }
        
        // Calculate date range: Today to 30 days from now
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let today = Date()
        let futureDate = Calendar.current.date(byAdding: .day, value: 30, to: today)!
        
        let fromDate = dateFormatter.string(from: today)
        let toDate = dateFormatter.string(from: futureDate)
        
        SportsAPIService.shared.fetchFixtures(leagueId: league.leagueKey, from: fromDate, to: toDate) { [weak self] result in
            switch result {
            case .success(let fixtures):
                self?.upcomingFixtures = fixtures
            case .failure(let error):
                print("Error fetching upcoming fixtures: \(error)")
            }
            completion()
        }
    }
    
    private func fetchLatestFixtures(completion: @escaping () -> Void) {
        guard let league = league else {
            completion()
            return
        }
        
        // Calculate date range: 30 days ago to yesterday
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let pastDate = Calendar.current.date(byAdding: .day, value: -30, to: Date())!
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        
        let fromDate = dateFormatter.string(from: pastDate)
        let toDate = dateFormatter.string(from: yesterday)
        
        
        SportsAPIService.shared.fetchFixtures(leagueId: league.leagueKey, from: fromDate, to: toDate) { [weak self] result in
            switch result {
            case .success(let fixtures):
                self?.latestFixtures = fixtures
            case .failure(let error):
                print("Error fetching latest fixtures: \(error)")
            }
            completion()
        }
    }
    
    private func fetchTeams(completion: @escaping () -> Void) {
        guard let league = league else {
            completion()
            return
        }
        
        SportsAPIService.shared.fetchTeams(inLeague: league.leagueKey) { [weak self] result in
            switch result {
            case .success(let teams):
                self?.teams = teams
            case .failure(let error):
                print("Error fetching teams: \(error)")
            }
            completion()
        }
    }
    
    private func updateUI() {
        upcomingEventsCollectionView.reloadData()
        latestEventsCollectionView.reloadData()
        teamsCollectionView.reloadData()
    }
    
    // MARK: - Actions
    @objc private func toggleFavorite() {
        // Implementation for CoreData saving
        // This would toggle the league's favorite status
    }
}

// MARK: - UICollectionViewDataSource
extension LeagueDetailsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == upcomingEventsCollectionView {
            return upcomingFixtures.count
        } else if collectionView == latestEventsCollectionView {
            return latestFixtures.count
        } else if collectionView == teamsCollectionView {
            return teams.count
        }
        return 0
    }
    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if collectionView == upcomingEventsCollectionView {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UpcomingEventsCell", for: indexPath) as! UpcomingEventsCell
//            cell.configure(with: upcomingFixtures[indexPath.item])
//            return cell
//
//        } else if collectionView == latestEventsCollectionView {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LatestEventsCell", for: indexPath) as! LatestEventsCell
//            cell.configure(with: latestFixtures[indexPath.item])
//            return cell
//
//        } else {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeamCell", for: indexPath) as! TeamCell
//            cell.configure(with: teams[indexPath.item])
//            return cell
//        }
//    }
}

// MARK: - UICollectionViewDelegate
extension LeagueDetailsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == teamsCollectionView {
            // Navigate to team details
            let team = teams[indexPath.item]
            performSegue(withIdentifier: "ShowTeamDetails", sender: team)
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "ShowTeamDetails",
//           let teamVC = segue.destination as? TeamDetailsViewController,
//           let team = sender as? Team {
//            teamVC.team = team
//        }
//    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension LeagueDetailsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == upcomingEventsCollectionView {
            return CGSize(width: 250, height: 100)
        } else if collectionView == latestEventsCollectionView {
            return CGSize(width: collectionView.frame.width - 32, height: 80)
        } else if collectionView == teamsCollectionView {
            return CGSize(width: 80, height: 100)
        }
        return CGSize.zero
    }
}
