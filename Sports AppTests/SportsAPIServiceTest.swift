//
//  SportsAPIService.swift
//  Sports AppTests
//
//  Created by Mustafa Hussain on 18/05/2025.
//

import XCTest
@testable import Sports_App

final class SportsAPIServiceTest: XCTestCase {
    
    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
    }
    
    
    func testFetchFootballLeagues(){
        let expectation = expectation(description: "Wait for network call")
        
        SportsAPIService.shared.fetchLeagues(sport: "football", completion: {resutl in
            switch resutl{
            case .success(let leagues):
                
                XCTAssert(leagues.count > 0)
                
                expectation.fulfill()
            case .failure(_):
                XCTFail()
            }
        })
        
        waitForExpectations(timeout: 5)
    }
    
    
    func testFeatchedFirstFootballLes(){
        let expectation = expectation(description: "Wait for network call")
        
        SportsAPIService.shared.fetchLeagues(sport: "football", completion: {resutl in
            switch resutl{
            case .success(let leagues):
                
                XCTAssert(leagues[0].leagueKey == 4)
                XCTAssert(leagues[0].leagueName == "UEFA Europa League")
                
                expectation.fulfill()
            case .failure(_):
                XCTFail()
            }
        })
        
        waitForExpectations(timeout: 5)
    }
    
    func testFetchTeamsForLeague10(){
        let expectation = expectation(description: "Wait for network call")
        
        SportsAPIService.shared.fetchTeams(sport: "football", inLeague: 10){resutl in
            switch resutl{
            case .success(let teams):
                
                XCTAssert(teams.count > 0)
                
                expectation.fulfill()
            case .failure(_):
                XCTFail()
            }
        }
        
        waitForExpectations(timeout: 5)
    }

    
    func testFetchFirstTeamForLeague10(){
        let expectation = expectation(description: "Wait for network call")
        
        SportsAPIService.shared.fetchTeams(sport: "football", inLeague: 10){resutl in
            switch resutl{
            case .success(let teams):
                
                XCTAssert(teams[0].teamKey == 359)
                XCTAssert(teams[0].teamName == "Al Ahli")
                
                expectation.fulfill()
            case .failure(_):
                XCTFail()
            }
        }
        
        waitForExpectations(timeout: 5)
    }
    
}
