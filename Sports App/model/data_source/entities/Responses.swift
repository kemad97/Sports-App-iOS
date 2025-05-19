//
//  Responses.swift
//  Sports App
//
//  Created by Kerolos on 13/05/2025.
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
