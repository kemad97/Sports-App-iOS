//
//  SportsReposatory.swift
//  Sports App
//
//  Created by Mustafa Hussain on 13/05/2025.
//

import Foundation

class SportsRepository{
    var localDataSource: LeaguesLocalDataSource!
    var remoteDataSource: SportsAPIService!
    
    init(remoteDataSource: SportsAPIService!, localDataSource: LeaguesLocalDataSource!) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }
    
    func getTeamDetails(sport: String,leagueId: Int, teamId: Int, completion: @escaping (Team?) -> Void){
        remoteDataSource.fetchTeam(sport: sport, inLeague: leagueId, teamId: teamId){response in
            switch response{
            case .success(let teams):
                completion(teams[0])
            case .failure(let error):
                print("Error: \(error)")
                completion(nil)
            }
        }
    }
    
    func addFavoriteLeague(leagueKey: Int, leagueName: String, leagueLogo: String, completion: @escaping(Bool)->Void){
        localDataSource.addFavoriteLeagu(leagueKey: Int32(leagueKey), leagueName: leagueName, leagueLogo: leagueLogo, completion: {result in
            switch result{
            case .success():
                completion(true)
            case .failure(_):
                completion(false)
            }
        })
    }
    
    func getFavoriteLeagues(completion: @escaping ([FavoriteLeagues]) -> Void){
        localDataSource.getFavoriteLeagues(completion: {result in
            switch result{
            case .success(let favoriteLeagues):
                completion(favoriteLeagues)
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                completion([])
            }
        })
    }
    
    func deleteFavoriteLeague(league: FavoriteLeagues, completion: @escaping(Bool)->Void){
        localDataSource.deleteFavoriteLeague(favoriteLeague: league, completion: {result in
            switch result{
            case .success():
                completion(true)
            case .failure(_):
                completion(false)
            }
        })
    }
    
}
