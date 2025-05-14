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
        }
        
        if let flowLayout = latestEventsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .vertical
            flowLayout.itemSize = CGSize(width: view.frame.width - 32, height: 80)
        }
        
        if let flowLayout = teamsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.itemSize = CGSize(width: 80, height: 100)
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
        print("Favorite button tapped")
    }
}

// MARK: - UICollectionViewDataSource
extension LeagueDetailsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == upcomingEventsCollectionView {
            return max(upcomingFixtures.count, 1) // At least show 1 cell
        } else if collectionView == latestEventsCollectionView {
            return max(latestFixtures.count, 1)
        } else if collectionView == teamsCollectionView {
            return max(teams.count, 1)
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == upcomingEventsCollectionView {
            // Try to dequeue the custom cell
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UpcomingEventsCell", for: indexPath) as? UpcomingEventsCell {
                if !upcomingFixtures.isEmpty && indexPath.item < upcomingFixtures.count {
                    let fixture = upcomingFixtures[indexPath.item]
                    cell.homeName.text = fixture.matchHometeamName
                    cell.awayName.text = fixture.matchAwayteamName
                    cell.date.text = fixture.matchDate
                    
                    cell.homeImg.kf.setImage(with: URL(string: fixture.teamHomeBadge ?? ""),
                                             placeholder: UIImage(named: "placeholder_team"))
                    cell.awayImg.kf.setImage(with: URL(string: fixture.teamAwayBadge ?? ""),
                                             placeholder: UIImage(named: "placeholder_team"))
                } else {
                    // Handle empty state
                    cell.homeName.text = "No upcoming fixtures"
                    cell.awayName.text = ""
                    cell.date.text = ""
                    cell.homeImg.image = UIImage(named: "placeholder_team")
                    cell.awayImg.image = UIImage(named: "placeholder_team")
                }
                return cell
            } else {
                // Fallback to basic cell if custom cell doesn't work
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BasicCell", for: indexPath)
                cell.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.3)
                cell.layer.cornerRadius = 10
                return cell
            }
        }
        else if collectionView == latestEventsCollectionView {
            // Try to dequeue the custom cell
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LatestEventsCell", for: indexPath) as? LatestEventsCell {
                if !latestFixtures.isEmpty && indexPath.item < latestFixtures.count {
                    let fixture = latestFixtures[indexPath.item]
                    cell.homeName.text = fixture.matchHometeamName
                    cell.awayName.text = fixture.matchAwayteamName
                    cell.homeScore.text = fixture.goalsHomeTeam ?? "0"
                    cell.awayScore.text = fixture.goalsAwayTeam ?? "0"
                    cell.date.text = fixture.matchDate
                    
                    cell.homeImg.kf.setImage(with: URL(string: fixture.teamHomeBadge ?? ""),
                                           placeholder: UIImage(named: "placeholder_team"))
                    cell.awayImg.kf.setImage(with: URL(string: fixture.teamAwayBadge ?? ""),
                                           placeholder: UIImage(named: "placeholder_team"))
                } else {
                    // Handle empty state
                    cell.homeName.text = "No recent fixtures"
                    cell.awayName.text = ""
                    cell.homeScore.text = ""
                    cell.awayScore.text = ""
                    cell.date.text = ""
                    cell.homeImg.image = UIImage(named: "placeholder_team")
                    cell.awayImg.image = UIImage(named: "placeholder_team")
                }
                return cell
            } else {
                // Fallback to basic cell if custom cell doesn't work
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BasicCell", for: indexPath)
                cell.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.3)
                cell.layer.cornerRadius = 10
                return cell
            }
        }
        else if collectionView == teamsCollectionView {
            // Try to dequeue the custom cell
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeamsCell", for: indexPath) as? TeamsCell {
                if !teams.isEmpty && indexPath.item < teams.count {
                    let team = teams[indexPath.item]
                    cell.teamName.text = team.teamName
                    
//                    cell.teamImg.kf.setImage(with: URL(string: team.teamLogo ?? ""),
//                                           placeholder: UIImage(named: "placeholder_team"))
                } else {
                    // Handle empty state
                    cell.teamName.text = "No teams"
                    cell.teamImg.image = UIImage(named: "placeholder_team")
                }
                return cell
            } else {
                // Fallback to basic cell if custom cell doesn't work
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BasicCell", for: indexPath)
                cell.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.3)
                cell.layer.cornerRadius = 10
                return cell
            }
        }
        else {
            // Fallback - should never reach here
            let cell = UICollectionViewCell()
            cell.backgroundColor = .red
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegate
extension LeagueDetailsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == teamsCollectionView && !teams.isEmpty && indexPath.item < teams.count {
            let team = teams[indexPath.item]
            print("Selected team: \(team.teamName)")
            // Navigate to team details page
        }
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
