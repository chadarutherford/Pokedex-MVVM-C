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
		label.textColor = .label
		label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
		return label
	}()
	
	let pokemonImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		return imageView
	}()

	var viewModel: FavoritePokemonTableViewCellViewModel! {
		didSet {
			updateViews()
		}
	}
	var pokemon: FavoritePokemon?
//		didSet {
//			updateViews()
//		}
//	}
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setup()
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setup() {
		isUserInteractionEnabled = true
		contentView.addSubview(pokemonImageView)
		contentView.addSubview(nameLabel)
		NSLayoutConstraint.activate([
			pokemonImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
			pokemonImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			pokemonImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
			pokemonImageView.widthAnchor.constraint(equalToConstant: 40),
			pokemonImageView.heightAnchor.constraint(equalToConstant: 40),
			
			nameLabel.centerYAnchor.constraint(equalTo: pokemonImageView.centerYAnchor),
			nameLabel.leadingAnchor.constraint(equalTo: pokemonImageView.trailingAnchor, constant: 16),
			nameLabel.trailingAnchor.constraint(greaterThanOrEqualTo: contentView.trailingAnchor, constant: -16)
		])
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
	}
	
	private func updateViews() {
		guard let pokemon = pokemon,
			  let imageURL = pokemon.imageURL
		else { return }
		nameLabel.text = pokemon.name?.capitalized
		viewModel.fetchImage(for: imageURL) { result in
			switch result {
			case .failure: fatalError()
			case .success(let image):
				self.pokemonImageView.image = image
			}
		}
	}
}

extension FavoritePokemonTableViewCell: ReuseIdentifiable {
	static var reuseIdentifier: String {
		String(describing: Self.self)
	}
}
