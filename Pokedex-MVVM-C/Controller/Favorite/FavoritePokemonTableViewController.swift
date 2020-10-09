//
//  FavoritePokemonTableViewController.swift
//  Pokedex-MVVM-C
//
//  Created by Chad Rutherford on 10/9/20.
//

import UIKit

final class FavoritePokemonTableViewController: UITableViewController {
	
	private var viewModel: FavoritePokemonViewModel
	private var coordinator: PokedexCoordinator
	
	init(coordinator: PokedexCoordinator, viewModel: FavoritePokemonViewModel) {
		self.coordinator = coordinator
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.register(FavoritePokemonTableViewCell.self, forCellReuseIdentifier: FavoritePokemonTableViewCell.reuseIdentifier)
	}
}
