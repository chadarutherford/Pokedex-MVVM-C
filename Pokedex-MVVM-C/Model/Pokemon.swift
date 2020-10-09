//
//  Pokemon.swift
//  Pokedex-MVVM-C
//
//  Created by Chad Rutherford on 10/9/20.
//

import UIKit

struct Pokemon: Codable, Equatable {
	let name: String
	let url: URL?
	var isSelected: Bool? = false
	var imageURL: URL?
	
	static func ==(lhs: Pokemon, rhs: Pokemon) -> Bool {
		lhs.name == rhs.name && lhs.url == rhs.url
	}
}

struct PokemonResult: Codable, Equatable {
	let results: [Pokemon]
	
	static func ==(lhs: PokemonResult, rhs: PokemonResult) -> Bool {
		lhs.results == rhs.results
	}
}

struct PokemonImage: Codable {
	var url: URL?
	
	enum PokemonKeys: String, CodingKey {
		case sprites
		case image = "front_default"
	}

	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: PokemonKeys.self)
		let spriteContainer = try container.nestedContainer(keyedBy: PokemonKeys.self, forKey: .sprites)
		self.url = try spriteContainer.decode(URL.self, forKey: .image)
	}
}
