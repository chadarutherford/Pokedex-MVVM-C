//
//  PokedexCollectionViewCell.swift
//  Pokedex-MVVM-C
//
//  Created by Chad Rutherford on 10/9/20.
//

import UIKit

protocol PokedexCollectionViewCellDelegate: AnyObject {
	func didCatch(pokemon: Pokemon, with imageURL: URL)
}

class PokedexCollectionViewCell: UICollectionViewCell {
	
	let pokemonImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = .scaleAspectFit
		imageView.isUserInteractionEnabled = true
		return imageView
	}()
	
	let nameLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "Bulbasaur"
		label.textColor = .label
		label.backgroundColor = .systemBackground
		label.textAlignment = .center
		return label
	}()
	
	weak var delegate: PokedexCollectionViewCellDelegate?
	private var imageCache = [URL: UIImage]()
	private var backgroundOperationQueue = OperationQueue()
	var viewModel: PokedexViewModel?
	var pokemon: Pokemon? {
		didSet {
			updateViews()
		}
	}
	var imageURL: URL?
	var caughtPokemon: Pokemon?
	
	override init(frame: CGRect) {
		super.init(frame: frame)
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
			pokemonImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
			pokemonImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
			pokemonImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -22),
			
			nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			nameLabel.topAnchor.constraint(equalTo: pokemonImageView.bottomAnchor),
			nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
		])
		pokemonImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pokemonCaught)))
	}
	
	private func updateViews() {
		guard let pokemon = pokemon, let url = pokemon.url else { return }
		if imageCache[url] == nil {
			fetchImage(for: url)
		} else {
			pokemonImageView.image = imageCache[url]
		}
		nameLabel.text = pokemon.name.capitalized
	}
	
	private func fetchImage(for url: URL) {
		guard let pokemon = pokemon else { return }
		let imageUrlOperation = BlockOperation { [weak self] in
			guard let self = self else { return }
			self.viewModel?.fetchData(with: url) { result in
				switch result {
				case .failure(let error):
					print(error)
				case .success(let pokemonImage):
					self.pokemon?.imageURL = pokemonImage.url
					self.caughtPokemon = Pokemon(name: pokemon.name, url: pokemon.url, isSelected: false, imageURL: pokemonImage.url)
				}
			}
		}
		let imageOperation = BlockOperation { [weak self] in
			guard let self = self else { return }
			if let imageURL = pokemon.imageURL {
				self.viewModel?.fetchImage(with: imageURL) { result in
					switch result {
					case .success(let image):
						self.pokemonImageView.image = image
						self.imageCache[url] = image
					case .failure: fatalError()
					}
				}
				self.imageURL = imageURL
			}
		}
		imageUrlOperation.addDependency(imageOperation)
		backgroundOperationQueue.addOperation(imageUrlOperation)
		OperationQueue.main.addOperation(imageOperation)
	}
	
	@objc
	private func pokemonCaught() {
		guard let pokemon = caughtPokemon, let imageURL = pokemon.imageURL else { return }
		delegate?.didCatch(pokemon: pokemon, with: imageURL)
	}
}

extension PokedexCollectionViewCell: ReuseIdentifiable {
	static var reuseIdentifier: String {
		String(describing: Self.self)
	}
}
