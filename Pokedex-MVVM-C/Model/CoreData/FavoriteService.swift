//
//  FavoriteService.swift
//  Pokedex-MVVM-C
//
//  Created by Chad Rutherford on 10/9/20.
//

import Foundation

final class FavoriteService {
	static let shared = FavoriteService()
	
	@discardableResult
	func add(_ name: String, imageURL: URL) -> FavoritePokemon {
		let favorite = FavoritePokemon(context: CoreDataStack.shared.mainContext)
		favorite.name = name
		favorite.imageURL = imageURL
		CoreDataStack.shared.saveContext()
		return favorite
	}
	
	func delete(_ favorite: FavoritePokemon) {
		CoreDataStack.shared.mainContext.delete(favorite)
		CoreDataStack.shared.saveContext()
	}
}
