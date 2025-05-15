//
//  Model.swift
//  Sports App
//
//  Created by Kerolos on 11/05/2025.
//

import Foundation


struct League: Codable {
    let leagueKey: Int
    let leagueName: String
    let leagueLogo: String?
    
    enum CodingKeys: String, CodingKey {
        case leagueKey = "league_key"
        case leagueName = "league_name"
        case leagueLogo = "league_logo"
    }
}

struct Team: Codable {
    let teamKey: Int
    let teamName: String
    let teamLogo: String?
    let players: [Player]?
    let coaches: [Coach]?
    
    // Additional details for team view
    let teamCountry: String?
    let teamFounded: String?
    let venueName: String?
    
    enum CodingKeys: String, CodingKey {
        case teamKey = "team_key"
        case teamName = "team_name"
        case teamLogo = "team_logo"
        case players
        case coaches
        case teamCountry = "team_country"
        case teamFounded = "team_founded"
        case venueName = "venue_name"
    }
}

struct Player: Codable {
    let playerKey: Int
    let playerName: String
    let playerNumber: String?
    let playerType: String?
    let playerImage: String?
    
    enum CodingKeys: String, CodingKey {
        case playerKey = "player_key"
        case playerName = "player_name"
        case playerNumber = "player_number"
        case playerType = "player_type"
        case playerImage = "player_image"
    }
}

struct Coach: Codable {
    let coachName: String
    
    enum CodingKeys: String, CodingKey {
        case coachName = "coach_name"
    }
}

struct Fixture: Codable {
    let eventKey: Int
    let eventDate: String
    let eventTime: String
    let eventHomeTeam: String
    let eventAwayTeam: String
    let homeTeamKey: Int
    let awayTeamKey: Int
    let homeTeamLogo: String?
    let awayTeamLogo: String?
    let eventFinalResult: String
    let leagueName: String
    let leagueKey: Int
    
    enum CodingKeys: String, CodingKey {
        case eventKey = "event_key"
        case eventDate = "event_date"
        case eventTime = "event_time"
        case eventHomeTeam = "event_home_team"
        case eventAwayTeam = "event_away_team"
        case homeTeamKey = "home_team_key"
        case awayTeamKey = "away_team_key"
        case homeTeamLogo = "home_team_logo"
        case awayTeamLogo = "away_team_logo"
        case eventFinalResult = "event_final_result"
        case leagueName = "league_name"
        case leagueKey = "league_key"

    }

}
