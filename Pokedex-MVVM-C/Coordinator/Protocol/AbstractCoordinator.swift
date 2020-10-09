//
//  AbstractCoordinator.swift
//  Pokedex-MVVM-C
//
//  Created by Chad Rutherford on 10/9/20.
//

import Foundation

protocol AbstractCoordinator {
	func addChildCoordinator(_ coordinator: AbstractCoordinator)
	func removeAllChildCoordinators<T>(with type: T.Type)
	func removeAllChildCoordinators()
}
