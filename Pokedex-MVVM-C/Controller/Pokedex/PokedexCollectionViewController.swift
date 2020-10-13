//
//  PokedexCollectionViewController.swift
//  Pokedex-MVVM-C
//
//  Created by Chad Rutherford on 10/9/20.
//

import UIKit

final class PokedexCollectionViewController: UICollectionViewController {
	
	private var factory: DependencyFactory?
	private var coordinator: PokedexCoordinator?
	private var pokedexCollectionView: PokedexCollectionView?
	private lazy var coreDataStack = CoreDataStack()
	private lazy var favoriteService = FavoriteService(managedObjectContext: coreDataStack.mainContext, coreDataStack: coreDataStack)
	private var viewModel: PokedexViewModel?
	
	init(factory: DependencyFactory, coordinator: PokedexCoordinator, viewModel: PokedexViewModel) {
		self.factory = factory
		self.coordinator = coordinator
		self.viewModel = viewModel
		let layout = UICollectionViewFlowLayout()
		super.init(collectionViewLayout: layout)
		viewModel.delegate = self
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func loadView() {
		if let navController = self.navigationController, let pokedexCollectionView = factory?.makePokedexCollectionView(navigationController: navController) {
			self.collectionView = pokedexCollectionView
			self.view = pokedexCollectionView
			title = "Pokedex"
		}
		navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.starFilled, style: .plain, target: self, action: #selector(moveToFavorites))
	}
	
	@objc
	private func moveToFavorites() {
		coordinator?.moveToFavorites()
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		viewModel?.results.count ?? 0
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokedexCollectionViewCell.reuseIdentifier, for: indexPath) as? PokedexCollectionViewCell else { fatalError("Unable to dequeue a PokemonCollectionViewCell") }
		cell.pokemon = viewModel?.results[indexPath.row]
		cell.viewModel = viewModel
		cell.delegate = self
		return cell
	}
}

extension PokedexCollectionViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		CGSize(width: (collectionView.frame.width / 3) - 30, height: 100)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
	}
}

extension PokedexCollectionViewController: PokedexCollectionViewCellDelegate {
	func didCatch(pokemon: Pokemon, with imageURL: URL) {
		favoriteService.add(pokemon.name, imageURL: imageURL)
	}
}

extension PokedexCollectionViewController: PokedexViewModelDelegate {
	func resultsWereSet() {
		collectionView.reloadData()
	}
}

extension PokedexCollectionViewController {
	override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		let offsetY = scrollView.contentOffset.y
		let contentHeight = scrollView.contentSize.height
		let height = scrollView.frame.size.height
		
		if offsetY > contentHeight - height {
			viewModel?.pageNumber += 20
			viewModel?.addPokemon(withPageNumber: viewModel?.pageNumber ?? 0)
		}
	}
}
