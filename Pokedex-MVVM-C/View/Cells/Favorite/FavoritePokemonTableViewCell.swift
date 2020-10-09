//
//  FavoritePokemonTableViewCell.swift
//  Pokedex-MVVM-C
//
//  Created by Chad Rutherford on 10/9/20.
//

import UIKit

class FavoritePokemonTableViewCell: UITableViewCell {
	var pokemon: FavoritePokemon? {
		didSet {
			updateViews()
		}
	}
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setup()
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setup() {
		
	}
	
	private func updateViews() {
		
	}
}

extension FavoritePokemonTableViewCell: ReuseIdentifiable {
	static var reuseIdentifier: String {
		String(describing: Self.self)
	}
}
