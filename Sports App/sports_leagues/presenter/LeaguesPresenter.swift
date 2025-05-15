//
//  LeaguesPresenter.swift
//  Sports App
//
//  Created by Mustafa Hussain on 12/05/2025.
//

import Foundation

class LeaguesPresenter{
    private weak var leaguesView : LeaguesView?
    
    init(view: LeaguesView){
        self.leaguesView = view
    }
    
    func getLeagues(sport: String){
        SportsAPIService.shared.fetchLeagues(sport: sport, completion: {[weak self] result in
            switch result{
            case .success(let leagues):
                self?.leaguesView?.displayLeagues(leagues)
            case .failure(let error):
                self?.leaguesView?.displayError(error.localizedDescription)
            }
        })
    }
    
}
