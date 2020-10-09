//
//  PokedexCollectionViewCell.swift
//  Pokedex-MVVM-C
//
//  Created by Chad Rutherford on 10/9/20.
//

import UIKit

protocol PokedexCollectionViewCellDelegate: AnyObject {
	func didAddFavorite(pokemon: Pokemon)
}

class PokedexCollectionViewCell: UICollectionViewCell {
	
	let favoriteButton: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setImage(UIImage.star, for: .normal)
		button.tintColor = .systemYellow
		return button
	}()
	
	let pokemonImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = .scaleAspectFit
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
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setup() {
		contentView.addSubview(pokemonImageView)
		pokemonImageView.addSubview(favoriteButton)
		contentView.addSubview(nameLabel)
		NSLayoutConstraint.activate([
			favoriteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
			favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
			
			pokemonImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
			pokemonImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
			pokemonImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
			pokemonImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -22),
			
			nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			nameLabel.topAnchor.constraint(equalTo: pokemonImageView.bottomAnchor),
			nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
		])
		favoriteButton.addTarget(self, action: #selector(favoriteAdded), for: .touchUpInside)
	}
	
	private func updateViews() {
		guard let pokemon = pokemon, let url = pokemon.url else { return }
		if imageCache[url] == nil {
			fetchImage(for: url)
		} else {
			pokemonImageView.image = imageCache[url]
		}
		nameLabel.text = pokemon.name.capitalized
		let image: UIImage = pokemon.isSelected ?? false ? .starFilled : .star
		favoriteButton.setImage(image, for: .normal)
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
			}
		}
		imageUrlOperation.addDependency(imageOperation)
		backgroundOperationQueue.addOperation(imageUrlOperation)
		OperationQueue.main.addOperation(imageOperation)
	}
	
	@objc
	private func favoriteAdded() {
		guard let pokemon = pokemon else { return }
		delegate?.didAddFavorite(pokemon: pokemon)
	}
}

extension PokedexCollectionViewCell: ReuseIdentifiable {
	static var reuseIdentifier: String {
		String(describing: Self.self)
	}
}
