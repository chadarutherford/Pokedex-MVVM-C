//
//  FavoritePokemonViewModel.swift
//  Pokedex-MVVM-C
//
//  Created by Chad Rutherford on 10/9/20.
//

import Foundation

class FavoritePokemonViewModel {
	
	var networkManager: HTTPManagerProtocol?
	private var coordinator: PokedexCoordinator?
	
	init(coordinator: PokedexCoordinator, networkManager: HTTPManagerProtocol) {
		self.coordinator = coordinator
		self.networkManager = networkManager
	}
}
