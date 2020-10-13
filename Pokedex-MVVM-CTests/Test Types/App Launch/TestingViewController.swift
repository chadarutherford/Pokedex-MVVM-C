//
//  TestingViewController.swift
//  Pokedex-MVVM-CTests
//
//  Created by Chad Rutherford on 10/12/20.
//

import UIKit

final class TestingRootViewController: UIViewController {
	override func loadView() {
		let label = UILabel()
		label.text = "Running tests....."
		label.textAlignment = .center
		label.textColor = .white
		view = label
	}
}
