//
//  FavoritePokemonTableViewController.swift
//  Pokedex-MVVM-C
//
//  Created by Chad Rutherford on 10/9/20.
//

import CoreData
import UIKit

final class FavoritePokemonTableViewController: UITableViewController {
	typealias FavoriteSnapshot = NSDiffableDataSourceSnapshot<Int, FavoritePokemon>
	typealias FavoriteDataSource = UITableViewDiffableDataSource<Int, FavoritePokemon>
	
	
	lazy var fetchedResultsController: NSFetchedResultsController<FavoritePokemon> = {
		let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
		let fetchRequest: NSFetchRequest<FavoritePokemon> = FavoritePokemon.fetchRequest()
		fetchRequest.sortDescriptors = [sortDescriptor]
		let fetchedResultsController = NSFetchedResultsController<FavoritePokemon>(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.mainContext, sectionNameKeyPath: nil, cacheName: nil)
		fetchedResultsController.delegate = self
		return fetchedResultsController
	}()
	
	lazy var dataSource:  FavoriteDataSource = {
		let dataSource = FavoriteDataSource(tableView: tableView) { tableView, indexPath, item -> UITableViewCell? in
			guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoritePokemonTableViewCell.reuseIdentifier, for: indexPath) as? FavoritePokemonTableViewCell else { fatalError("Unable to dequeue a FavoritePokemonTableViewCell") }
			cell.pokemon = item
			cell.viewModel = self.viewModel
			return cell
		}
		return dataSource
	}()
	
	var viewModel: FavoritePokemonTableViewCellViewModel!
	private var coordinator: PokedexCoordinator
	
	
	init(coordinator: PokedexCoordinator) {
		self.coordinator = coordinator
		super.init(nibName: nil, bundle: nil)
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.register(FavoritePokemonTableViewCell.self, forCellReuseIdentifier: FavoritePokemonTableViewCell.reuseIdentifier)
		tableView.rowHeight = 56
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		UIView.performWithoutAnimation {
			do {
				try fetchedResultsController.performFetch()
			} catch let error as NSError {
				print("Fetching error: \(error), \(error.userInfo)")
			}
		}
	}
	
	private func updateSnapshot() {
		var diffableDataSourceSnapshot = FavoriteSnapshot()
		diffableDataSourceSnapshot.appendSections([0])
		diffableDataSourceSnapshot.appendItems(fetchedResultsController.fetchedObjects ?? [])
		dataSource.apply(diffableDataSourceSnapshot)
	}
}

extension FavoritePokemonTableViewController: NSFetchedResultsControllerDelegate {
	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
		updateSnapshot()
	}
}
