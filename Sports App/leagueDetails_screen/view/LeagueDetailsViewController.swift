import UIKit
import Kingfisher

class LeagueDetailsViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var upcomingEventsCollectionView: UICollectionView!
    @IBOutlet weak var latestEventsCollectionView: UICollectionView!
    @IBOutlet weak var teamsCollectionView: UICollectionView!
    
    // MARK: - Properties
    var league: League!
    private var upcomingFixtures: [Fixture] = []
    private var latestFixtures: [Fixture] = []
    private var teams: [Team] = []
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        fetchData()
    }
    
    // MARK: - UI Setup
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
        
        // Configure flow layouts
        if let flowLayout = upcomingEventsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.itemSize = CGSize(width: 250, height: 100)
            flowLayout.minimumLineSpacing = 12
        }
        
        if let flowLayout = latestEventsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .vertical
            flowLayout.itemSize = CGSize(width: view.frame.width - 32, height: 80)
            flowLayout.minimumLineSpacing = 10
        }
        
        if let flowLayout = teamsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.itemSize = CGSize(width: 80, height: 100)
            flowLayout.minimumLineSpacing = 16
        }
        
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
                print("✅ Fetched \(fixtures.count) upcoming fixtures")
            case .failure(let error):
                print("❌ Error fetching upcoming fixtures: \(error)")
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
                print("✅ Fetched \(fixtures.count) latest fixtures")
            case .failure(let error):
                print("❌ Error fetching latest fixtures: \(error)")
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
                print("✅ Fetched \(teams.count) teams")
            case .failure(let error):
                print("❌ Error fetching teams: \(error)")
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
        print("Favorite button tapped - League: \(league?.leagueName ?? "")")
    }
}

// MARK: - UICollectionViewDataSource
extension LeagueDetailsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == upcomingEventsCollectionView {
            return upcomingFixtures.count > 0 ? upcomingFixtures.count : 1
        } else if collectionView == latestEventsCollectionView {
            return latestFixtures.count > 0 ? latestFixtures.count : 1
        } else if collectionView == teamsCollectionView {
            return teams.count > 0 ? teams.count : 1
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == upcomingEventsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UpcomingEventsCell", for: indexPath) as! UpcomingEventsCell
            
            if upcomingFixtures.count > 0 && indexPath.item < upcomingFixtures.count {
                let fixture = upcomingFixtures[indexPath.item]
                
                // Set text data
                cell.homeName.text = fixture.matchHometeamName
                cell.awayName.text = fixture.matchAwayteamName
                cell.date.text = formatDate(fixture.matchDate)
                cell.scoreLabel.text = "-"
                
                // Load images with Kingfisher
                if let homeImageURL = URL(string: fixture.teamHomeBadge ?? "") {
                    cell.homeImg.kf.setImage(with: homeImageURL, placeholder: UIImage(named: "placeholder_team"))
                }
                
                if let awayImageURL = URL(string: fixture.teamAwayBadge ?? "") {
                    cell.awayImg.kf.setImage(with: awayImageURL, placeholder: UIImage(named: "placeholder_team"))
                }
            } else {
                // Show placeholder or empty state
                cell.homeName.text = "No upcoming matches"
                cell.awayName.text = ""
                cell.date.text = ""
                cell.scoreLabel.text = ""
                cell.homeImg.image = nil
                cell.awayImg.image = nil
            }
            
            return cell
        }
//        else if collectionView == latestEventsCollectionView {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LatestEventsCell", for: indexPath) as! LatestEventsCell
//
//            if latestFixtures.count > 0 && indexPath.item < latestFixtures.count {
//                let fixture = latestFixtures[indexPath.item]
//
//                // Set text data
//                cell.homeName.text = fixture.matchHometeamName
//                cell.awayName.text = fixture.matchAwayteamName
//                cell.homeScore.text = fixture.goalsHomeTeam ?? "0"
//                cell.awayScore.text = fixture.goalsAwayTeam ?? "0"
//                cell.date.text = formatDate(fixture.matchDate)
//
//                // Load images with Kingfisher
//                if let homeImageURL = URL(string: fixture.teamHomeBadge ?? "") {
//                    cell.homeImg.kf.setImage(with: homeImageURL, placeholder: UIImage(named: "placeholder_team"))
//                }
//
//                if let awayImageURL = URL(string: fixture.teamAwayBadge ?? "") {
//                    cell.awayImg.kf.setImage(with: awayImageURL, placeholder: UIImage(named: "placeholder_team"))
//                }
//            }
//            return cell
//        }
//        else if collectionView == teamsCollectionView {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeamCell", for: indexPath) as! TeamCell
//
//            if teams.count > 0 && indexPath.item < teams.count {
//                let team = teams[indexPath.item]
//
//                // Set text data
//                cell.teamName.text = team.teamName
//
//                // Load team image with Kingfisher
//                if let teamImageURL = URL(string: team.teamLogo ?? "") {
//                    cell.teamImg.kf.setImage(with: teamImageURL, placeholder: UIImage(named: "placeholder_team"))
//                }
//            } else {
//                // Show placeholder or empty state
//                cell.teamName.text = "No teams"
//                cell.teamImg.image = UIImage(named: "placeholder_team")
//            }
//
//            return cell
//        }
//
        // Default fallback cell - should never reach this
        let cell = UICollectionViewCell()
        cell.backgroundColor = .red
        return cell
    }
    
    // Helper method to format dates
    private func formatDate(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = inputFormatter.date(from: dateString) else { return dateString }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "MMM d, yyyy"
        return outputFormatter.string(from: date)
    }
}

// MARK: - UICollectionViewDelegate
extension LeagueDetailsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        if collectionView == teamsCollectionView && teams.count > 0 && indexPath.item < teams.count {
        //            let team = teams[indexPath.item]
        //
        //            // Navigate to team details
        //            let storyboard = UIStoryboard(name: "TeamDetails", bundle: nil)
        ////            if let teamDetailsVC = storyboard.instantiateViewController(withIdentifier: "TeamDetailsViewController") as? TeamDetailsCollectionViewCell {
        ////                teamDetailsVC.teamId = team
        ////                navigationController?.pushViewController(teamDetailsVC, animated: true)
        ////            }
        ////        }
        //    }
    }
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
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        }
    }

