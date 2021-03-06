//
//  PokedexCoordinator.swift
//  Pokedex-MVVM-C
//
//  Created by Chad Rutherford on 10/9/20.
//

import UIKit

class PokedexCoordinator: AbstractCoordinator, RootCoordinator {
	private(set) var childCoordinators = [AbstractCoordinator]()
	weak var navigationController: UINavigationController?
	private var factory: Factory
	
	init(factory: Factory) {
		self.factory = factory
	}
	
	func addChildCoordinator(_ coordinator: AbstractCoordinator) {
		childCoordinators.append(coordinator)
	}
	
	func removeAllChildCoordinators<T>(with type: T.Type) {
		childCoordinators = childCoordinators.filter { $0 is T == false }
	}
	
	func removeAllChildCoordinators() {
		childCoordinators.removeAll()
	}
	
	func start(_ navigationController: UINavigationController) {
		let vc = factory.makePokedexCollectionViewController(coordinator: self)
		self.navigationController = navigationController
		navigationController.pushViewController(vc, animated: true)
	}
	
	func moveToFavorites() {
		let vc = factory.makeFavoritePokemonTableViewController(coordinator: self)
		vc.viewModel = factory.makeFavoriteViewModel()
		navigationController?.pushViewController(vc, animated: true)
	}
}
