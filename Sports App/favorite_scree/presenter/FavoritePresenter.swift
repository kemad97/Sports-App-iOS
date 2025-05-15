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
            if favoriteLeagues.isEmpty{
                self?.favoriteView.displayError(message: "No Favorite Leagues Found")
            }else{
                self?.favoriteView.displayFavorites(leagues: favoriteLeagues)
            }
        })
    }
    
}
