//
//  SportsReposatory.swift
//  Sports App
//
//  Created by Mustafa Hussain on 13/05/2025.
//

import Foundation

class SportsReposatory{
//    var localDataSource: LocalDataSource!
    var remoteDataSource: SportsAPIService!
    
    init(remoteDataSource: SportsAPIService!) {
        self.remoteDataSource = remoteDataSource
    }
    
    func getTeamDetails(leagueId: Int, teamId: Int, completion: @escaping (Team?) -> Void){
        remoteDataSource.fetchTeam(inLeague: leagueId, teamId: teamId){response in
            switch response{
            case .success(let teams):
                completion(teams[0])
            case .failure(let error):
                print("Error: \(error)")
                completion(nil)
            }
        }
    }
    
}
