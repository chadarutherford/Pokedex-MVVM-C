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
	private lazy var coreDataStack = CoreDataStack()
	private lazy var favoriteService = FavoriteService(managedObjectContext: coreDataStack.mainContext, coreDataStack: coreDataStack)
	
	lazy var fetchedResultsController: NSFetchedResultsController<FavoritePokemon> = {
		let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
		let fetchRequest: NSFetchRequest<FavoritePokemon> = FavoritePokemon.fetchRequest()
		fetchRequest.sortDescriptors = [sortDescriptor]
		let fetchedResultsController = NSFetchedResultsController<FavoritePokemon>(fetchRequest: fetchRequest, managedObjectContext: coreDataStack.mainContext, sectionNameKeyPath: nil, cacheName: nil)
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
		tableView.isUserInteractionEnabled = true
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
	
	override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
		.delete
	}
	
	override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let delete = UIContextualAction(
			style: .destructive,
			title: "Delete") { (action, view, completion) in
			guard let favorite = self.dataSource.itemIdentifier(for: indexPath) else { return }
			self.favoriteService.delete(favorite)
			self.updateSnapshot()
			completion(true)
		}
		delete.image = .trash
		return UISwipeActionsConfiguration(actions: [delete])
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
