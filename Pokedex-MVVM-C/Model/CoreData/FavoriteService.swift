//
//  FavoriteService.swift
//  Pokedex-MVVM-C
//
//  Created by Chad Rutherford on 10/9/20.
//

import CoreData
import Foundation

final class FavoriteService {
	
	var managedObjectContext: NSManagedObjectContext
	var coreDataStack: CoreDataStack
	
	init(managedObjectContext: NSManagedObjectContext,
		 coreDataStack: CoreDataStack) {
		self.coreDataStack = coreDataStack
		self.managedObjectContext = managedObjectContext
	}
	
	@discardableResult
	func add(_ name: String, imageURL: URL) -> FavoritePokemon {
		let favorite = FavoritePokemon(context: managedObjectContext)
		favorite.name = name
		favorite.imageURL = imageURL
		coreDataStack.saveContext(managedObjectContext)
		return favorite
	}
	
	public func getFavorites() -> [FavoritePokemon]? {
		let reportFetch: NSFetchRequest<FavoritePokemon> = FavoritePokemon.fetchRequest()
		do {
			let results = try managedObjectContext.fetch(reportFetch)
			return results
		} catch let error as NSError {
			fatalError("Fetch error: \(error), description: \(error.userInfo)")
		}
	}
	
	func delete(_ favorite: FavoritePokemon) {
		coreDataStack.mainContext.delete(favorite)
		coreDataStack.saveContext()
	}
}
