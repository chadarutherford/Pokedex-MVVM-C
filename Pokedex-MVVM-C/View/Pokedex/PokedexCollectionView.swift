//
//  PokedexCollectionView.swift
//  Pokedex-MVVM-C
//
//  Created by Chad Rutherford on 10/9/20.
//

import UIKit

class PokedexCollectionView: UICollectionView {
	
	weak var navController: UINavigationController?
	
	init(navigationController: UINavigationController, frame: CGRect = .zero, collectionViewLayout: UICollectionViewLayout = UICollectionViewFlowLayout()) {
		self.navController = navigationController
		super.init(frame: frame, collectionViewLayout: collectionViewLayout)
		setup()
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setup() {
		backgroundColor = .systemBackground
		register(PokedexCollectionViewCell.self, forCellWithReuseIdentifier: PokedexCollectionViewCell.reuseIdentifier)
	}
}
