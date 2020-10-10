//
//  DependencyFactory.swift
//  Pokedex-MVVM-C
//
//  Created by Chad Rutherford on 10/9/20.
//

import UIKit

protocol Factory {
	var networkManager: HTTPManagerProtocol { get }
	func makePokedexCollectionViewController(coordinator: PokedexCoordinator) -> PokedexCollectionViewController
	func makePokedexViewModel(coordinator: RootCoordinator) -> PokedexViewModel
	func makePokedexCoordinator() -> PokedexCoordinator
	func makePokedexCollectionView(navigationController: UINavigationController) -> PokedexCollectionView
	func makeFavoritePokemonTableViewController(coordinator: PokedexCoordinator) -> FavoritePokemonTableViewController
}

class DependencyFactory: Factory {
	var networkManager: HTTPManagerProtocol = HTTPManager()
	
	func makePokedexCoordinator() -> PokedexCoordinator {
		let coordinator = PokedexCoordinator(factory: self)
		return coordinator
	}
	
	func makePokedexCollectionViewController(coordinator: PokedexCoordinator) -> PokedexCollectionViewController {
		let viewModel = makePokedexViewModel(coordinator: coordinator)
		let pokedexCollectionVC = PokedexCollectionViewController(factory: self, coordinator: coordinator, viewModel: viewModel)
		return pokedexCollectionVC
	}
	
	func makePokedexCollectionView(navigationController: UINavigationController) -> PokedexCollectionView {
		let pokedexCollectionView = PokedexCollectionView(navigationController: navigationController)
		return pokedexCollectionView
	}
	
	func makePokedexViewModel(coordinator: RootCoordinator) -> PokedexViewModel {
		let viewModel = PokedexViewModel(coordinator: coordinator, networkManager: networkManager)
		return viewModel
	}
}

// MARK: - Favorites
extension DependencyFactory {
	func makeFavoritePokemonTableViewController(coordinator: PokedexCoordinator) -> FavoritePokemonTableViewController {
		let favoritePokemonTableViewController = FavoritePokemonTableViewController(coordinator: coordinator)
		return favoritePokemonTableViewController
	}
}
