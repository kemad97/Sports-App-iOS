//
//  LeagueDetailsPresenter.swift
//  Sports App
//
//  Created by Kerolos on 16/05/2025.
//

import Foundation
import SkeletonView

class LeagueDetailsPresenter {
    
    private let repository : SportsRepository
    weak private var view : LeagueDetailsView?
    private let league : League
     var sport: String!

    
    // State
    private var upcomingFixtures: [Fixture] = []
    private var latestFixtures: [Fixture] = []
    private var teams: [Team] = []
    private var isFavorite = false
    
    init(view:LeagueDetailsView,repository: SportsRepository, league: League) {
        self.view = view
        self.repository=repository
        self.league=league
    }
    
    func viewDidLoad () {
        view?.showSkeleton()
        checkIfFavorite()
        fetchData()
    }
    
    func setSport(_ sport:String){
        self.sport=sport
    }
    
    
    func toggleFavorite() {
        if isFavorite {
            removeFavorite()
        } else {
            addFavorite()
        }
    }
    
    func didSelectTeam(at index: Int) {
        guard index < teams.count else { return }
        let selectedTeam = teams[index]
        view?.navigateToTeamDetails(team: selectedTeam)
    }
    
    
    private func fetchData() {
          let group = DispatchGroup()
          
          group.enter()
          fetchUpcomingFixtures { group.leave() }
          
          group.enter()
          fetchLatestFixtures { group.leave() }
          
          group.enter()
          fetchTeams { group.leave() }
          
          group.notify(queue: .main) { [weak self] in
              guard let self = self else { return }
              self.view?.hideSkeleton()
              self.view?.updateUI(upcomingFixtures: self.upcomingFixtures,
                                  latestFixtures: self.latestFixtures,
                                  teams: self.teams)
          }
      }
    
    private func fetchUpcomingFixtures(completion: @escaping () -> Void) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let today = Date()
            let futureDate = Calendar.current.date(byAdding: .day, value: 14, to: today)!
            
            let fromDate = dateFormatter.string(from: today)
            let toDate = dateFormatter.string(from: futureDate)
            
        repository.remoteDataSource.fetchFixtures(sport:sport, leagueId: league.leagueKey, from: fromDate, to: toDate) { [weak self] result in
                switch result {
                case .success(let fixtures):
                    self?.upcomingFixtures = fixtures
                case .failure(let error):
                    print("Error fetching upcoming fixtures: \(error)")
                }
                completion()
            }
        }
    
    
    private func fetchLatestFixtures(completion: @escaping () -> Void) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let pastDate = Calendar.current.date(byAdding: .day, value: -14, to: Date())!
            let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
            
            let fromDate = dateFormatter.string(from: pastDate)
            let toDate = dateFormatter.string(from: yesterday)
            
            repository.remoteDataSource.fetchFixtures(sport:sport,leagueId: league.leagueKey, from: fromDate, to: toDate) { [weak self] result in
                switch result {
                case .success(let fixtures):
                    self?.latestFixtures = fixtures
                case .failure(let error):
                    print("Error fetching latest fixtures: \(error)")
                }
                completion()
            }
        }
        
        private func fetchTeams(completion: @escaping () -> Void) {
            repository.remoteDataSource.fetchTeams(sport:sport,inLeague: league.leagueKey) { [weak self] result in
                switch result {
                case .success(let teams):
                    self?.teams = teams
                case .failure(let error):
                    print("Error fetching teams: \(error)")
                }
                completion()
            }
        }
    
    private func checkIfFavorite() {
          repository.getFavoriteLeagues { [weak self] favorites in
              guard let self = self else { return }
              self.isFavorite = favorites.contains { $0.key == Int32(self.league.leagueKey) }
              self.view?.updateFavoriteButton(isFavorite: self.isFavorite)
          }
      }
    
    private func addFavorite() {
        repository.addFavoriteLeague(leagueKey: league.leagueKey, leagueName: league.leagueName, leagueLogo: league.leagueLogo ?? "", completion: {
            [weak self] success in
            if success {
                self?.isFavorite=true
                self?.view?.updateFavoriteButton(isFavorite: true)
            }
            else{
                self?.view?.showError(message: "Failed to add favorite")
            }
        })
    }
    private func removeFavorite() {
           repository.getFavoriteLeagues { [weak self] favorites in
               guard let self = self else { return }
               
               if let favoriteLeague = favorites.first(where: { $0.key == Int32(self.league.leagueKey) }) {
                   
                   self.repository.deleteFavoriteLeague(league: favoriteLeague) { success in
                       if success {
                           self.isFavorite = false
                           self.view?.updateFavoriteButton(isFavorite: false)
                       } else {
                           self.view?.showError(message: "Failed to remove favorite")
                       }
                   }
               }
           }
       }
}

