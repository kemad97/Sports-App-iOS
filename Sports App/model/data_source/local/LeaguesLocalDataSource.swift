//
//  LocalDataSource.swift
//  Sports App
//
//  Created by Mustafa Hussain on 15/05/2025.
//


import UIKit
import CoreData

class LeaguesLocalDataSource {
    func getFavoriteLeagues(
        completion: @escaping (Result<[FavoriteLeagues], Error>) -> Void
    ) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch favorites"])))
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<FavoriteLeagues> = FavoriteLeagues.fetchRequest()
        

        if let result = try? context.fetch(fetchRequest) {
            completion(.success(result))
        }
    }

}
