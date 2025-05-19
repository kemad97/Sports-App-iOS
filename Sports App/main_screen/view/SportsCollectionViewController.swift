//
//  SportsCollectionViewController.swift
//  Sports App
//
//  Created by Mustafa Hussain on 19/05/2025.
//

import UIKit


class SportsCollectionViewController: UICollectionViewController {

    
    var sportName: String = ""
    
    private var sportsData: [Sport] = [
        Sport(id: 0, imagePath: "football_card_image", title: "Football"),
        Sport(id: 1, imagePath: "cricket_card_image", title: "Cricket"),
        Sport(id: 2, imagePath: "tennis_card_image", title: "Tennis"),
        Sport(id: 3, imagePath: "basketball_card_image", title: "Basketball")
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewCompositionalLayout {
            index,
            environement in
                self.drawSportsCard()
        }
        self.collectionView.setCollectionViewLayout(layout, animated: true)

        
    }
    
    func drawSportsCard() -> NSCollectionLayoutSection {
        // Item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 4, bottom: 8, trailing: 4)

        // Group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(320)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item, item] // Two items per row
        )

        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        return section
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: UIScreen.main.bounds.size.width/2 - 10, height: UIScreen.main.bounds.size.height/2 - 10)
    }
    
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SportsCellTableViewCell
        
        cell.sportImage?.image = UIImage(named: sportsData[indexPath.row].imagePath)
        cell.sportTitle?.text = sportsData[indexPath.row].title
        
        //make image and title rounded
        cell.sportImage.layer.cornerRadius = 12
        cell.sportImage.layer.masksToBounds = true
        
        cell.sportTitle.layer.cornerRadius = 8
        cell.sportTitle.layer.masksToBounds = true
    
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (NetworkMonitor.shared.isConnected){
            let storyboard = UIStoryboard(name: "SportsLeagues", bundle: nil)
            if let sportsVC = storyboard.instantiateViewController(withIdentifier: "LeagueTableViewController") as? LeagueTableViewController {
                
                sportsVC.sportName = sportsData[indexPath.row].title
                
                navigationController?.pushViewController(sportsVC, animated: true)
            } else {
                print("Failed to instantiate SportsViewController from SportsLeagues.storyboard")
            }
        }
        
        else {
            let alert = UIAlertController(
                title: "No Internet Connection",
                message: "Please check your connection and try again.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true )
        }
    }
}
