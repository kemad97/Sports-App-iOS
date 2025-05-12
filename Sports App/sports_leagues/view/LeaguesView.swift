//
//  LeaguesView.swift
//  Sports App
//
//  Created by Mustafa Hussain on 12/05/2025.
//

import Foundation

protocol LeaguesView : AnyObject{
    func displayLeagues(_ leagues: [League])
    func displayError(_ message: String)
}
