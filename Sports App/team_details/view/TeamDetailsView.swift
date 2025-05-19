//
//  TeamsDetailsView.swift
//  Sports App
//
//  Created by Mustafa Hussain on 13/05/2025.
//

import Foundation

protocol TeamDetailsView{
    func displayTeamDetails(teamDetails: Team)
    func displayErrorMessage(message:String)
}
