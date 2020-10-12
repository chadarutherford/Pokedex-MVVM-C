//
//  FavoritePokemonTableViewCellViewModel.swift
//  Pokedex-MVVM-C
//
//  Created by Chad Rutherford on 10/12/20.
//

import UIKit

final class FavoritePokemonTableViewCellViewModel {
	
	private var networkManager: HTTPManagerProtocol!
	
	init(networkManager: HTTPManagerProtocol) {
		self.networkManager = networkManager
	}
	
	func fetchImage(for url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
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
