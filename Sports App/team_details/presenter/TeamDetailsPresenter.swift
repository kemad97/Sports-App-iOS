//
//  TeamDetailsPresenter.swift
//  Sports App
//
//  Created by Mustafa Hussain on 13/05/2025.
//

import Foundation

class TeamDetailsPresenter {
    var teamDetailsView: TeamDetailsView?
    var reposatory: SportsReposatory!

    init(view: TeamDetailsView, reposatory: SportsReposatory) {
        self.teamDetailsView = view
        self.reposatory = reposatory
    }

    func getTeamDetails(leagueId: Int, teamId: Int) {
        reposatory.getTeamDetails(
            leagueId: leagueId,
            teamId: teamId,
            completion: { [weak self] team in
                guard let team = team else {
                    self?.teamDetailsView?.displayErrorMessage(
                        message: "No data retreaved"
                    )
                    return
                }
                self?.teamDetailsView?.displayTeamDetails(teamDetails: team)
            }
        )
    }

}
