//
//  TeamDetailsCollectionViewController.swift
//  Sports App
//
//  Created by Mustafa Hussain on 13/05/2025.
//

import UIKit


class TeamDetailsCollectionViewController: UICollectionViewController {

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
            widthDimension: .absolute(200),
            heightDimension: .absolute(230)
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
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 75,
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
            heightDimension: .absolute(200)
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
            bottom: 16,
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
            return 1
        default:
            return 10
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

        return cell
    }
}
