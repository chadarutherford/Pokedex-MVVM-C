//
//  PokemonImageTests.swift
//  Pokedex-MVVM-CTests
//
//  Created by Chad Rutherford on 10/12/20.
//

@testable import Pokedex_MVVM_C
import XCTest

class PokemonImageTests: XCTestCase, DecodableTestCase {
	
	var dictionary: NSDictionary!
	var sut: PokemonImage!

	override func setUp() {
		super.setUp()
		try! givenSUTFromJSON()
	}
	
	func testConformsToDecodable() {
		XCTAssertTrue((sut as Any) is Decodable)
	}
	
	func testConformsToEquatable() {
		XCTAssertEqual(sut, sut)
	}
	
	func testDecodableSetsImageURL() {
		XCTAssertEqual(sut.url, URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/4.png"))
	}
	
	override func tearDown() {
		dictionary = nil
		sut = nil
		super.tearDown()
	}
}
