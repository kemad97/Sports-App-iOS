import UIKit
import SkeletonView
import Kingfisher

class LeagueCollectionViewController: UICollectionViewController ,LeagueDetailsView , SkeletonCollectionViewDataSource{
    
   
    
    // MARK: - Properties
    var league: League!
    private var upcomingFixtures: [Fixture] = []
    private var latestFixtures: [Fixture] = []
    private var teams: [Team] = []
    private var presenter: LeagueDetailsPresenter!

    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
          super.viewDidLoad()
          
          // Setup presenter
          let localDataSource = LeaguesLocalDataSource()
          let remoteDataSource = SportsAPIService.shared
          let repository = SportsRepository(remoteDataSource: remoteDataSource, localDataSource: localDataSource)
        presenter = LeagueDetailsPresenter(view:self,repository: repository, league: league)
          
          // Setup skeleton
          setupSkeletonView()
          
          // Register header
          collectionView.register(
              SectionHeaderView.self,
              forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
              withReuseIdentifier: SectionHeaderView.reuseIdentifier
          )
          
          setupUI()
          setupCollectionViewLayout()
          
          // Start loading data
          presenter.viewDidLoad()
      }
    

    
    private func setupSkeletonView() {
        // Make collection view skeletonable
        collectionView.isSkeletonable = true
        
        // Set up skeleton appearance
        SkeletonAppearance.default.multilineHeight = 15
        SkeletonAppearance.default.multilineSpacing = 10
        SkeletonAppearance.default.multilineLastLineFillPercent = 80
        SkeletonAppearance.default.gradient = SkeletonGradient(baseColor: .systemGray6)
    }
    
    // MARK: - LeagueDetailsView Protocol Methods
      func showSkeleton() {
          DispatchQueue.main.async {
              let gradient = SkeletonGradient(baseColor: .systemGray6)
              self.collectionView.showAnimatedGradientSkeleton(usingGradient: gradient)
          }
      }
      
      func hideSkeleton() {
          DispatchQueue.main.async {
              self.collectionView.hideSkeleton(reloadDataAfter: true)
          }
      }
    
    
    
    func updateUI(upcomingFixtures: [Fixture], latestFixtures: [Fixture], teams: [Team]) {
            self.upcomingFixtures = upcomingFixtures
            self.latestFixtures = latestFixtures
            self.teams = teams
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    func showError(message: String) {
           DispatchQueue.main.async {
               let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
               alert.addAction(UIAlertAction(title: "OK", style: .default))
               self.present(alert, animated: true)
           }
       }
    
    func navigateToTeamDetails(team: Team) {
            // Implement navigation to team details screen
            print("Navigate to team: \(team.teamName)")
        }
    
    func updateFavoriteButton(isFavorite: Bool) {
           DispatchQueue.main.async {
               let imageName = isFavorite ? "heart.fill" : "heart"
               let button = UIBarButtonItem(
                   image: UIImage(systemName: imageName),
                   style: .plain,
                   target: self,
                   action: #selector(self.toggleFavorite)
               )
               button.tintColor = .systemRed
               self.navigationItem.rightBarButtonItem = button
           }
       }
    
    @objc private func toggleFavorite() {
          presenter.toggleFavorite()
      }
    // MARK: - UI Setup
    private func setupUI() {
        title = league?.leagueName ?? "League Details"
        
        // Configure collection view
        collectionView.backgroundColor = .systemBackground
        
        // Add favorite button (will be updated by presenter)
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "heart"),
            style: .plain,
            target: self,
            action: #selector(toggleFavorite)
        )
        navigationItem.rightBarButtonItem?.tintColor = .systemRed
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
            heightDimension: .absolute(85)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(85)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 16, trailing: 8)
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
    
    // MARK: - SkeletonCollectionViewDataSource
     func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
         switch indexPath.section {
         case 0:
             return "UpcomingEventsCell"
         case 1:
             return "LatestEventsCell"
         case 2:
             return "TeamsCell"
         default:
             return "BasicCell"
         }
     }
     
     func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         switch section {
         case 0: return 2
         case 1: return 3
         case 2: return 4
         default: return 0
         }
     }
     
     func numSections(in collectionSkeletonView: UICollectionView) -> Int {
         return 3
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
            if upcomingFixtures.isEmpty {
                configureUpcomingCell(cell, with: nil)  // Pass nil to trigger empty state
            } else {
                configureUpcomingCell(cell, with: upcomingFixtures[indexPath.item])
            }
            return cell
            
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LatestEventsCell", for: indexPath) as! LatestEventsCell
            if latestFixtures.isEmpty {
                configureLatestCell(cell, with: nil)  // Pass nil to trigger empty state
            } else {
                configureLatestCell(cell, with: latestFixtures[indexPath.item])
            }
            return cell
            
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeamsCell", for: indexPath) as! TeamsCell
            if teams.isEmpty {
                configureTeamCell(cell, with: nil)  // Pass nil to trigger empty state
            } else {
                configureTeamCell(cell, with: teams[indexPath.item])
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
    
    private func configureUpcomingCell(_ cell: UpcomingEventsCell, with fixture: Fixture?) {
        // If fixture is nil, show placeholder content
        if let fixture = fixture {
            // Normal case - we have data
            cell.homeName.text = fixture.eventHomeTeam
            cell.awayName.text = fixture.eventAwayTeam
            cell.date.text = fixture.eventDate
            
            cell.homeImg.kf.setImage(
                with: URL(string: fixture.homeTeamLogo ?? ""),
                placeholder: UIImage(named: "team_placeholder")
            )
            cell.awayImg.kf.setImage(
                with: URL(string: fixture.awayTeamLogo ?? ""),
                placeholder: UIImage(named: "team_placeholder")
            )
        } else {
            // Empty state with placeholder content
            cell.homeImg.image = UIImage(named: "team_placeholder")
            cell.awayImg.image = UIImage(named: "team_placeholder")
            cell.homeName.text = ""
            cell.awayName.text = ""
            cell.date.text = "Check back later"
        }
    }
    
    private func configureLatestCell(_ cell: LatestEventsCell, with fixture: Fixture?) {
        if let fixture = fixture {
            // Normal case - we have data
            cell.homeName.text = fixture.eventHomeTeam
            cell.awayName.text = fixture.eventAwayTeam
            cell.finalScore.text = fixture.eventFinalResult
            
            cell.homeImg.kf.setImage(
                with: URL(string: fixture.homeTeamLogo ?? ""),
                placeholder: UIImage(named: "team_placeholder")
            )
            cell.awayImg.kf.setImage(
                with: URL(string: fixture.awayTeamLogo ?? ""),
                placeholder: UIImage(named: "team_placeholder")
            )
        } else {
            // Empty state
            cell.homeImg.image = UIImage(named: "team_placeholder")
            cell.awayImg.image = UIImage(named: "team_placeholder")
            cell.homeName.text = "No recent"
            cell.awayName.text = "No recent"
            cell.finalScore.text = "0 - 0"
        }
    }
    
    private func configureTeamCell(_ cell: TeamsCell, with team: Team?) {
        if let team = team {
            // Normal case - we have data
            cell.teamName.text = team.teamName
            
            cell.teamImg.kf.setImage(
                with: URL(string: team.teamLogo ?? "" ),
                placeholder: UIImage(named: "team_placeholder")
            )
        } else {
            // Empty state
            cell.teamImg.image = UIImage(named: "team_placeholder")
            cell.teamName.text = "No teams found"
        }
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
