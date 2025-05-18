//
//  ApiService.swift
//  Sports App
//
//  Created by Kerolos on 11/05/2025.
//

import Alamofire
import Foundation
import UIKit
import Network

class SportsAPIService {
    
    static let shared = SportsAPIService()
    
    private let networkMonitor = NetworkMonitor.shared
    private var hasShownNetworkAlert = false

    // API details - use your actual API key
    private let baseURL = "https://apiv2.allsportsapi.com"
    private let apiKey = "89c2658d2da76ab2a89e27553066deadfd3a09be5baa04cf5fb86f5354fee97b"
    
    private init() {}
    
    
    private func checkNetworkAndProceed (allowOfflineMode:Bool, completion: @escaping (Bool) -> Void){
        if (networkMonitor.isConnected){
            hasShownNetworkAlert=false
            completion(true)
        }
        
        else if (allowOfflineMode)
        {
            completion(false)
        }
        
        else {
            if (!hasShownNetworkAlert){
                hasShownNetworkAlert=false
                showNoNetworkAlert()
            }
            let error = NSError(domain: "NetworkError", code: -1009)
            completion(false)
        }
    }
    
    // Show network alert
    private func showNoNetworkAlert() {
        DispatchQueue.main.async {
            if let topVC = UIApplication.shared.windows.first?.rootViewController?.topMostViewController() {
                // Check that we're not already showing an alert
                if !(topVC is UIAlertController) {
                    let alert = UIAlertController(
                        title: "No Internet Connection",
                        message: "Please check your connection and try again.",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    topVC.present(alert, animated: true)
                }
            }
        }
    }
    
    // MARK: - Football Leagues
    func fetchLeagues(sport: String, completion: @escaping (Result<[League], Error>) -> Void) {
        
        checkNetworkAndProceed(allowOfflineMode: false) {
            connected in
            guard connected else{
                completion(.failure(NSError(domain: "NetworkError", code: -1009, userInfo: [NSLocalizedDescriptionKey: "No internet connection"])))
                return
            }
        }
        
        let endpoint = "\(baseURL)/\(sport.lowercased())"
        
        let parameters: [String: Any] = [
            "met": "Leagues",
            "APIkey": apiKey
        ]
        
        AF.request(endpoint, parameters: parameters)
            .validate()
            .responseDecodable(of: LeaguesResponse.self) { response in
                switch response.result {
                case .success(let leaguesResponse):
                    completion(.success(leaguesResponse.result))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    // MARK: - Teams in a League
    func fetchTeams(sport: String,inLeague leagueId: Int, completion: @escaping (Result<[Team], Error>) -> Void) {
        
        checkNetworkAndProceed(allowOfflineMode: false) {
            connected in
            guard connected else{
                completion(.failure(NSError(domain: "NetworkError", code: -1009, userInfo: [NSLocalizedDescriptionKey: "No internet connection"])))
                return
            }
        }
        
        
        let endpoint = "\(baseURL)/\(sport.lowercased())"

        let parameters: [String: Any] = [
            "met": "Teams",
            "leagueId": leagueId,
            "APIkey": apiKey
        ]
        
        AF.request(endpoint, parameters: parameters)
            .validate()
            .responseDecodable(of: TeamsResponse.self) { response in
                switch response.result {
                case .success(let teamsResponse):
                    completion(.success(teamsResponse.result))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    // MARK: - Team Details in a League
    func fetchTeam(sport: String,inLeague leagueId: Int, teamId: Int, completion: @escaping (Result<[Team], Error>) -> Void) {
        
        checkNetworkAndProceed(allowOfflineMode: false) {
            connected in
            guard connected else{
                completion(.failure(NSError(domain: "NetworkError", code: -1009, userInfo: [NSLocalizedDescriptionKey: "No internet connection"])))
                return
            }
        }
        
        let endpoint = "\(baseURL)/\(sport.lowercased())"

        let parameters: [String: Any] = [
            "met": "Teams",
            "leagueId": leagueId,
            "teamId": teamId,
            "APIkey": apiKey
        ]
        
        AF.request(endpoint, parameters: parameters)
            .validate()
            .responseDecodable(of: TeamsResponse.self) { response in
                switch response.result {
                case .success(let teamsResponse):
                    completion(.success(teamsResponse.result))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    // MARK: - Fixtures (Events)
    func fetchFixtures(sport: String, leagueId: Int, from: String, to: String, completion: @escaping (Result<[Fixture], Error>) -> Void) {
        
        checkNetworkAndProceed(allowOfflineMode: false) {
            connected in
            guard connected else{
                completion(.failure(NSError(domain: "NetworkError", code: -1009, userInfo: [NSLocalizedDescriptionKey: "No internet connection"])))
                return
            }
        }
        
           let endpoint = "\(baseURL)/\(sport.lowercased())"
        
        let parameters: [String: Any] = [
            "met": "Fixtures",
            "leagueId": leagueId,
            "from": from,  // Format: YYYY-MM-DD
            "to": to,      // Format: YYYY-MM-DD
            "APIkey": apiKey
        ]
        
        AF.request(endpoint, parameters: parameters)
            .validate()
            .responseDecodable(of: FixturesResponse.self) { response in
                switch response.result {
                case .success(let fixturesResponse):
                    completion(.success(fixturesResponse.result))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    // MARK: - Team Details
    func fetchTeamDetails(sport:String, teamId: Int, completion: @escaping (Result<Team, Error>) -> Void) {
        
        checkNetworkAndProceed(allowOfflineMode: false) {
            connected in
            guard connected else{
                completion(.failure(NSError(domain: "NetworkError", code: -1009, userInfo: [NSLocalizedDescriptionKey: "No internet connection"])))
                return
            }
        }
        
        let endpoint = "\(baseURL)/\((sport).lowercased())"
        
        let parameters: [String: Any] = [
            "met": "Teams",
            "teamId": teamId,
            "APIkey": apiKey
        ]
        
        AF.request(endpoint, parameters: parameters)
            .validate()
            .responseDecodable(of: TeamDetailsResponse.self) { response in
                switch response.result {
                case .success(let teamResponse):
                    if let team = teamResponse.result.first {
                        completion(.success(team))
                    } else {
                        completion(.failure(NSError(domain: "SportAPI", code: 404, userInfo: [NSLocalizedDescriptionKey: "No team data found"])))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    
}


extension UIViewController {
    func topMostViewController() -> UIViewController {
        if let presented = presentedViewController {
            return presented.topMostViewController()
        }
        if let nav = self as? UINavigationController {
            return nav.visibleViewController?.topMostViewController() ?? nav
        }
        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMostViewController() ?? tab
        }
        return self
    }
}
