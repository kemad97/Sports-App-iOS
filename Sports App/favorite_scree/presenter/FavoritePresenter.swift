//
//  FavoritePresenter.swift
//  Sports App
//
//  Created by Mustafa Hussain on 15/05/2025.
//

import Foundation

class FavoritePresenter{
    private var repo : SportsReposatory!
    private var favoriteView: FavoriteView!
    
    init(view : FavoriteView, repo : SportsReposatory){
        self.favoriteView = view
        self.repo = repo
    }
    
    func getFavoriteLeagues(){
        repo.getFavoriteLeagues(completion: {[weak self] favoriteLeagues in
            self?.favoriteView.displayFavorites(leagues: favoriteLeagues)
        })
    }
    
    
    func deleteFavoriteLeague(favoriteLeague: FavoriteLeagues){
        repo.deleteFavoriteLeague(league: favoriteLeague){[weak self] isDeleted in
            if isDeleted{
                self?.favoriteView.leagueDeleteSuccess()
            }else{
                self?.favoriteView.displayError(message: "Delete Favorite League Failed")
            }
        }
    }
    
}
