//
//  TeamDetailsCollectionViewController.swift
//  Sports App
//
//  Created by Mustafa Hussain on 13/05/2025.
//

import Kingfisher
import UIKit

class TeamDetailsCollectionViewController: UICollectionViewController,
    TeamDetailsView
{

    var leagueId: Int?
    var teamId: Int?

    private var teamDetails: Team?
    private var teamPresenter: TeamDetailsPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()

        let layout = UICollectionViewCompositionalLayout {
            index,
            environement in
            switch index {
            case 0:
                return self.drawTeamSection()
            default:
                return self.drawPlayersSection()
            }
        }
        self.collectionView.setCollectionViewLayout(layout, animated: true)

        //just for test
        //provide this data to send request
        leagueId = 10
        teamId = 360
        
        guard let leagueId = leagueId, let teamId = teamId else { return }
        
        teamPresenter = TeamDetailsPresenter(view: self, reposatory: SportsReposatory(remoteDataSource: SportsAPIService()))
        
        teamPresenter.getTeamDetails(leagueId: leagueId, teamId: teamId)
    }

    func drawTeamSection() -> NSCollectionLayoutSection {
        //item size

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )

        // item >> size
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        //groupsize
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(355),
            heightDimension: .absolute(244)
        )

        //group >> size , item
        let myGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )

        myGroup.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 0,
            bottom: 0,
            trailing: 0
        )

        //section >> group
        let section = NSCollectionLayoutSection(group: myGroup)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 32,
            leading: 16,
            bottom: 16,
            trailing: 16
        )
        return section
    }

    func drawPlayersSection() -> NSCollectionLayoutSection {
        //item size

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )

        // item >> size
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        //groupsize

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(100)
        )

        //group >> size , item
        let myGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )

        myGroup.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 0,
            bottom: 0,
            trailing: 0
        )

        //section >> group
        let section = NSCollectionLayoutSection(group: myGroup)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 16,
            bottom: 8,
            trailing: 16
        )

        return section
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        // #warning Incomplete implementation, return the number of items
        switch section {
        case 0:
            return (teamDetails != nil) ? 1 : 0
        default:
            return teamDetails?.players?.count ?? 0
        }
    }

    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {

        switch indexPath.section {
        case 0:  //team section
            return renderTeamCell(indexPath: indexPath)
        default:  //players section
            return renderPlayerCell(indexPath: indexPath)
        }
    }

    func renderTeamCell(indexPath: IndexPath)
        -> TeamDetailsCollectionViewCell
    {
        let cell =
            collectionView.dequeueReusableCell(
                withReuseIdentifier: "teamDataCell",
                for: indexPath
            ) as! TeamDetailsCollectionViewCell

        //fill cell data for team
        cell.teamImage.kf.setImage(
            with: URL(string: teamDetails?.teamLogo ?? ""),
            placeholder: UIImage(named: "team_placeholder")
        )

        cell.teamName.text = teamDetails?.teamName ?? ""
        cell.teamCoachName.text = "Coach: \(teamDetails?.coaches?[0].coachName ?? "")"

        return cell
    }

    func renderPlayerCell(indexPath: IndexPath)
        -> PlayerDetailsCollectionViewCell
    {
        let cell =
            collectionView.dequeueReusableCell(
                withReuseIdentifier: "playerDataCell",
                for: indexPath
            ) as! PlayerDetailsCollectionViewCell

        //fill cell data for player
        cell.playerImage.kf.setImage(
            with: URL(
                string: teamDetails?.players?[indexPath.row].playerImage ?? ""
            ),
            placeholder: UIImage(named: "player_placeholder")
        )
        cell.playerName.text = teamDetails?.players?[indexPath.row].playerName ?? ""
        let playerNumber = teamDetails?.players?[indexPath.row].playerNumber ?? "0"
        cell.playerNumber.text = "#\(playerNumber)"
        cell.playerPosition.text = teamDetails?.players?[indexPath.row].playerType ?? ""

        return cell
    }

    func displayTeamDetails(teamDetails: Team) {
        self.teamDetails = teamDetails
        collectionView.reloadData()
    }

    func displayErrorMessage(message: String) {
        print("Error: \(message)")
        //show uialert to infort user there are an error happend
    }

}
