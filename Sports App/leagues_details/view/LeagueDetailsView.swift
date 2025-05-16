//
//  LeagueDetailsView.swift
//  Sports App
//
//  Created by Kerolos on 16/05/2025.
//

import Foundation
protocol LeagueDetailsView:AnyObject {
    func updateUI(upcomingFixtures: [Fixture], latestFixtures: [Fixture], teams: [Team])
    func showError (message:String)
    func navigateToTeamDetails (team:Team)
    func updateFavoriteButton (isFavorite:Bool)
    func showSkeleton()
    func hideSkeleton()
}
