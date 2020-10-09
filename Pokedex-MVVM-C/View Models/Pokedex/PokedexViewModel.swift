//
//  PokedexViewModel.swift
//  Pokedex-MVVM-C
//
//  Created by Chad Rutherford on 10/9/20.
//

import UIKit

protocol PokedexViewModelDelegate: AnyObject {
	func resultsWereSet()
}

final class PokedexViewModel {
	weak var delegate: PokedexViewModelDelegate?
	private var networkManager: HTTPManagerProtocol?
	private(set) var results: PokemonResult?
	
	init(coordinator: RootCoordinator?, networkManager: HTTPManagerProtocol) {
		self.networkManager = networkManager
		fetchData { result in
			switch result {
			case .failure: fatalError("Unable to decode Pokemon Results")
			case .success(let results):
				self.results = results
				self.delegate?.resultsWereSet()
			}
		}
	}
	
	func fetchData(completion: @escaping (Result<PokemonResult, Error>) -> Void) {
		guard let url = API.baseURL?.appendingPathComponent(API.pokemonList) else { return }
		networkManager?.get(url: url) { result in
			DispatchQueue.main.async {
				switch result {
				case .failure(let error):
					completion(.failure(error))
				case .success(let data):
					let decoder = JSONDecoder()
					do {
						let results = try decoder.decode(PokemonResult.self, from: data)
						completion(.success(results))
					} catch {
						completion(.failure(error))
					}
				}
			}
		}
	}
	
	func fetchData(with url: URL, completion: @escaping (Result<PokemonImage, Error>) -> Void) {
		networkManager?.get(url: url) { result in
			DispatchQueue.main.async {
				switch result {
				case .failure(let error):
					completion(.failure(error))
				case .success(let data):
					let decoder = JSONDecoder()
					do {
						let results = try decoder.decode(PokemonImage.self, from: data)
						completion(.success(results))
					} catch {
						completion(.failure(error))
					}
				}
			}
		}
	}
	
	func fetchImage(with url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
		networkManager?.get(url: url) { result in
			DispatchQueue.main.async {
				switch result {
				case .failure(let error):
					completion(.failure(error))
				case .success(let data):
					guard let image = UIImage(data: data) else { return }
					completion(.success(image))
				}
			}
		}
	}
}
