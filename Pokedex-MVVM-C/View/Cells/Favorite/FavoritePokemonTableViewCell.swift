//
//  FavoritePokemonTableViewCell.swift
//  Pokedex-MVVM-C
//
//  Created by Chad Rutherford on 10/9/20.
//

import UIKit

class FavoritePokemonTableViewCell: UITableViewCell {
	
	let nameLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.backgroundColor = .purple
		return label
	}()
	
	let pokemonImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.backgroundColor = .blue
		return imageView
	}()
	
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
		contentView.addSubview(pokemonImageView)
		contentView.addSubview(nameLabel)
		NSLayoutConstraint.activate([
			pokemonImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
			pokemonImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			pokemonImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 16),
			pokemonImageView.widthAnchor.constraint(equalToConstant: 40),
			pokemonImageView.heightAnchor.constraint(equalTo: pokemonImageView.widthAnchor, multiplier: 1),
			
			nameLabel.centerYAnchor.constraint(equalTo: pokemonImageView.centerYAnchor),
			nameLabel.leadingAnchor.constraint(equalTo: pokemonImageView.trailingAnchor, constant: 16),
			nameLabel.trailingAnchor.constraint(greaterThanOrEqualTo: contentView.trailingAnchor, constant: -16)
		])
	}
	
	private func updateViews() {
		
	}
}

extension FavoritePokemonTableViewCell: ReuseIdentifiable {
	static var reuseIdentifier: String {
		String(describing: Self.self)
	}
}
