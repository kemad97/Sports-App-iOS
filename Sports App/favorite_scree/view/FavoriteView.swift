//
//  FavoriteView.swift
//  Sports App
//
//  Created by Mustafa Hussain on 15/05/2025.
//

import Foundation

protocol FavoriteView{
    func displayFavorites(leagues: [FavoriteLeagues])
    func leagueDeleteSuccess()
    func displayError(message: String)
}
