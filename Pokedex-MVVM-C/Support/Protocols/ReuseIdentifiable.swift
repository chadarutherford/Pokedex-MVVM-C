//
//  ReuseIdentifiable.swift
//  Pokedex-MVVM-C
//
//  Created by Chad Rutherford on 10/9/20.
//

import Foundation

protocol ReuseIdentifiable {
	static var reuseIdentifier: String { get }
}
