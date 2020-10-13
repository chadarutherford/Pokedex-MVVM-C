//
//  FavoriteDataSource.swift
//  Pokedex-MVVM-C
//
//  Created by Chad Rutherford on 10/12/20.
//

import UIKit

class FavoriteDataSource: UITableViewDiffableDataSource<Int, FavoritePokemon> {
	
	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}
}
