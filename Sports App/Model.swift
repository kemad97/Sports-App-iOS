//
//  Model.swift
//  Sports App
//
//  Created by Kerolos on 11/05/2025.
//

import Foundation

struct LeaguesResponse: Codable {
    let success: Int
    let result: [League]
}

struct TeamsResponse: Codable {
    let success: Int
    let result: [Team]
}

struct TeamDetailsResponse: Codable {
    let success: Int
    let result: [Team]
}

struct FixturesResponse: Codable {
    let success: Int
    let result: [Fixture]
}

// MARK: - Data Models
struct League: Codable {
    let leagueKey: Int
    let leagueName: String
    let countryKey: Int
    let countryName: String
    let leagueLogo: String?
    
    enum CodingKeys: String, CodingKey {
        case leagueKey = "league_key"
        case leagueName = "league_name"
        case countryKey = "country_key"
        case countryName = "country_name"
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
    let matchId: Int
    let leagueId: Int
    let leagueName: String
    let matchDate: String
    let matchTime: String
    let matchHometeamId: Int
    let matchHometeamName: String
    let matchAwayteamId: Int
    let matchAwayteamName: String
    let teamHomeBadge: String?
    let teamAwayBadge: String?
    let goalsHomeTeam: String?
    let goalsAwayTeam: String?
    
    enum CodingKeys: String, CodingKey {
        case matchId = "match_id"
        case leagueId = "league_id"
        case leagueName = "league_name"
        case matchDate = "match_date"
        case matchTime = "match_time"
        case matchHometeamId = "match_hometeam_id"
        case matchHometeamName = "match_hometeam_name"
        case matchAwayteamId = "match_awayteam_id"
        case matchAwayteamName = "match_awayteam_name"
        case teamHomeBadge = "team_home_badge"
        case teamAwayBadge = "team_away_badge"
        case goalsHomeTeam = "match_hometeam_score"
        case goalsAwayTeam = "match_awayteam_score"
    }
}
