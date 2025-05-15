//
//  LocalDataSource.swift
//  Sports App
//
//  Created by Mustafa Hussain on 15/05/2025.
//


import UIKit
import CoreData

class LeaguesLocalDataSource {
    
    func addFavoriteLeagu(favoriteLeague: FavoriteLeagues, completion: @escaping (Result<Void, Error>) -> Void){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to add new favorite league"])))
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let league = FavoriteLeagues(context: context)
        league.key = favoriteLeague.key
        league.logo = favoriteLeague.logo
        league.name = favoriteLeague.name
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
    
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
    
    func deleteFavoriteLeague(favoriteLeague: FavoriteLeagues,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Faild to delete favorite"])))
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        context.delete(favoriteLeague)

            do {
                try context.save()
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
    }

}
