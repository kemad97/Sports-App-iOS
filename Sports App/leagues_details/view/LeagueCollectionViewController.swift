import UIKit
import Kingfisher

class LeagueCollectionViewController: UICollectionViewController {
    
    // MARK: - Properties
    var league: League!
    private var upcomingFixtures: [Fixture] = []
    private var latestFixtures: [Fixture] = []
    private var teams: [Team] = []
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    private let localDataSource = LeaguesLocalDataSource()
    private var isFavorite = false
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Register header
        collectionView.register(
            SectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeaderView.reuseIdentifier
        )
        setupUI()
        setupCollectionViewLayout()
        checkIfFavorite()
        fetchData()
    }
    
    private func checkIfFavorite() {
        localDataSource.getFavoriteLeagues { [weak self] result in
            switch result {
            case .success(let favorites):
                // Check if current league is in favorites
                self?.isFavorite = favorites.contains { $0.key == (self?.league.leagueKey)! }
                self?.updateFavoriteButton()
            case .failure(let error):
                print("Error fetching favorites: \(error)")
            }
        }
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        title = league?.leagueName ?? "League Details"
        
        // Setup activity indicator
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        
        // Configure collection view
        collectionView.backgroundColor = .systemBackground
        
        // Add favorite button
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "heart"),
            style: .plain,
            target: self,
            action: #selector(toggleFavorite)
        )
        
        // Configure flow layout
        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.minimumInteritemSpacing = 10
            flowLayout.minimumLineSpacing = 10
            flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    private func setupCollectionViewLayout() {
        let layout = CustomCollectionViewLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.collectionViewLayout = layout
        
        // Configure section specific layouts
        collectionView.collectionViewLayout = createLayout()
    }
    
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnvironment in
            switch sectionIndex {
            case 0:
                // Horizontal scroll for upcoming events
                return self?.createUpcomingSection()
            case 1:
                // Vertical scroll for latest events
                return self?.createLatestSection()
            case 2:
                // Horizontal scroll for teams
                return self?.createTeamsSection()
            default:
                return nil
            }
        }
    }
    
    private func createUpcomingSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(120)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.9),
            heightDimension: .absolute(120)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 20, trailing: 16)
        section.interGroupSpacing = 12
        
        // Add header
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    private func createLatestSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(100)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(100)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 20, trailing: 16)
        section.interGroupSpacing = 16
        
        // Add header
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    private func createTeamsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(80),
            heightDimension: .absolute(150)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(80),
            heightDimension: .absolute(150)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 20, trailing: 16)
        section.interGroupSpacing = 12
        
        // Add header
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    // MARK: - Data Fetching
    private func fetchData() {
        guard league != nil else { return }
        
        activityIndicator.startAnimating()
        
        let group = DispatchGroup()
        
        group.enter()
        fetchUpcomingFixtures { group.leave() }
        
        group.enter()
        fetchLatestFixtures { group.leave() }
        
        group.enter()
        fetchTeams { group.leave() }
        
        group.notify(queue: .main) { [weak self] in
            self?.activityIndicator.stopAnimating()
            self?.collectionView.reloadData()
        }
    }
    
    private func fetchUpcomingFixtures(completion: @escaping () -> Void) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let today = Date()
        let futureDate = Calendar.current.date(byAdding: .day, value: 14, to: today)!
        
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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let pastDate = Calendar.current.date(byAdding: .day, value: -14, to: Date())!
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
    private func updateFavoriteButton() {
        let imageName = isFavorite ? "heart.fill" : "heart"
        let button = UIBarButtonItem(
            image: UIImage(systemName: imageName),
            style: .plain,
            target: self,
            action: #selector(toggleFavorite)
        )
        button.tintColor = .systemRed  // Set the color to red
        navigationItem.rightBarButtonItem = button
    }
    
    @objc private func toggleFavorite() {
        if isFavorite {
            // Remove from favorites
            localDataSource.getFavoriteLeagues { [weak self] result in
                switch result {
                case .success(let favorites):
                    if let favoriteLeague = favorites.first(where: { $0.key == (self?.league.leagueKey)! }) {
                        self?.localDataSource.deleteFavoriteLeague(favoriteLeague: favoriteLeague) { result in
                            switch result {
                            case .success:
                                DispatchQueue.main.async {
                                    self?.isFavorite = false
                                    self?.updateFavoriteButton()
                                }
                            case .failure(let error):
                                print("Error removing favorite: \(error)")
                            }
                        }
                    }
                case .failure(let error):
                    print("Error fetching favorites: \(error)")
                }
            }
        } else {
            // Add to favorites
            localDataSource.addFavoriteLeagu(
                leagueKey: Int32(league.leagueKey),
                leagueName: league.leagueName,
                leagueLogo: league.leagueLogo ?? ""
            ) { [weak self] result in
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        self?.isFavorite = true
                        self?.updateFavoriteButton()
                    }
                case .failure(let error):
                    print("Error adding favorite: \(error)")
                }
            }
        }
    }
    
}

// MARK: - UICollectionViewDataSource
extension LeagueCollectionViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3 // Upcoming, Latest, Teams sections
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return max(upcomingFixtures.count, 1)
        case 1: return max(latestFixtures.count, 1)
        case 2: return max(teams.count, 1)
        default: return 0
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UpcomingEventsCell", for: indexPath) as! UpcomingEventsCell
            if !upcomingFixtures.isEmpty {
                let fixture = upcomingFixtures[indexPath.item]
                configureUpcomingCell(cell, with: fixture)
            }
            return cell
            
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LatestEventsCell", for: indexPath) as! LatestEventsCell
            if !latestFixtures.isEmpty {
                let fixture = latestFixtures[indexPath.item]
                configureLatestCell(cell, with: fixture)
            }
            return cell
            
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeamsCell", for: indexPath) as! TeamsCell
            if !teams.isEmpty {
                let team = teams[indexPath.item]
                configureTeamCell(cell, with: team)
            }
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SectionHeaderView.reuseIdentifier,
                for: indexPath
            ) as! SectionHeaderView
            
            switch indexPath.section {
            case 0: header.configure(with: "Upcoming Events")
            case 1: header.configure(with: "Latest Events")
            case 2: header.configure(with: "Teams")
            default: header.configure(with: "")
            }
            
            return header
        }
        return UICollectionReusableView()
    }
    
    private func configureUpcomingCell(_ cell: UpcomingEventsCell, with fixture: Fixture) {
        cell.homeName.text = fixture.eventHomeTeam
        cell.awayName.text = fixture.eventAwayTeam
        cell.date.text = fixture.eventDate
        
        cell.homeImg.kf.setImage(
            with: URL(string: fixture.homeTeamLogo ?? ""),
            placeholder: UIImage(named: "placeholder_team")
        )
        cell.awayImg.kf.setImage(
            with: URL(string: fixture.awayTeamLogo ?? ""),
            placeholder: UIImage(named: "placeholder_team")
        )
    }
    
    private func configureLatestCell(_ cell: LatestEventsCell, with fixture: Fixture) {
        cell.homeName.text = fixture.eventHomeTeam
        cell.awayName.text = fixture.eventAwayTeam
        cell.finalScore.text = fixture.eventFinalResult
        
        cell.homeImg.kf.setImage(
            with: URL(string: fixture.homeTeamLogo ?? ""),
            placeholder: UIImage(named: "placeholder_team")
        )
        cell.awayImg.kf.setImage(
            with: URL(string: fixture.awayTeamLogo ?? ""),
            placeholder: UIImage(named: "placeholder_team")
        )
    }
    
    private func configureTeamCell(_ cell: TeamsCell, with team: Team) {
        cell.teamName.text = team.teamName
        cell.teamImg.kf.setImage(
            with: URL(string: team.teamLogo ?? ""),
            placeholder: UIImage(named: "placeholder_team")
        )
    }
}

// MARK: - UICollectionViewDelegate
extension LeagueCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 2 && !teams.isEmpty {
            let team = teams[indexPath.item]
            print("Selected team: \(team.teamName)")
            // Handle team selection
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension LeagueCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 32
        
        switch indexPath.section {
        case 0: return CGSize(width: 250, height: 100)
        case 1: return CGSize(width: width, height: 80)
        case 2: return CGSize(width: 80, height: 100)
        default: return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 40)
    }
}


class SectionHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "SectionHeader"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func configure(with title: String) {
        titleLabel.text = title
    }
}
