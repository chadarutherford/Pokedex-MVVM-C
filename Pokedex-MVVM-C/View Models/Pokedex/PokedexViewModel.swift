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
	private(set) var results = [Pokemon]()
	var pageNumber = 0
	
	init(coordinator: RootCoordinator?, networkManager: HTTPManagerProtocol) {
		self.networkManager = networkManager
		fetchData(withPageNumber: pageNumber) { result in
			switch result {
			case .failure(let error):
				print(error)
			case .success(let results):
				self.results.append(contentsOf: results.results)
				self.delegate?.resultsWereSet()
			}
		}
	}
	
	func fetchData(withPageNumber pageNumber: Int, completion: @escaping (Result<PokemonResult, Error>) -> Void) {
		guard let baseURL = API.baseURL?.appendingPathComponent(API.pokemonList) else { return }
		if pageNumber > 0 {
			var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
			let offsetItem = URLQueryItem(name: "offset", value: "\(pageNumber)")
			let limitItem = URLQueryItem(name: "limit", value: "20")
			urlComponents?.queryItems = [offsetItem, limitItem]
			guard let url = urlComponents?.url else { return }
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
		} else {
			networkManager?.get(url: baseURL) { result in
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
	
	func addPokemon(withPageNumber pageNumber: Int) {
		fetchData(withPageNumber: pageNumber) { results in
			switch results {
			case .failure(let error):
				print(error)
			case .success(let results):
				self.results.append(contentsOf: results.results)
				self.delegate?.resultsWereSet()
			}
		}
	}
}
