//
//  PokedexViewModel.swift
//  Pokedex-MVVM-C
//
//  Created by Chad Rutherford on 10/9/20.
//

import Foundation

final class PokedexViewModel {
	private var networkManager: HTTPManagerProtocol?
	init(coordinator: RootCoordinator?, networkManager: HTTPManagerProtocol) {
		self.networkManager = networkManager
	}
	
	func fetchData(completion: @escaping (Result<[Pokemon], Error>) -> Void) {
		networkManager?.get(url: URL(string: "NOURL")!) { result in
			DispatchQueue.main.async {
				switch result {
				case .failure(let error):
					completion(.failure(error))
				case .success(let data):
					if let str = String(data: data, encoding: .utf8) {
						let model = Pokemon(string: str)
						completion(.success([model]))
					}
				}
			}
		}
	}
}
