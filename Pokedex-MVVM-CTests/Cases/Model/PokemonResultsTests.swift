//
//  PokemonTests.swift
//  Pokedex-MVVM-CTests
//
//  Created by Chad Rutherford on 10/9/20.
//

@testable import Pokedex_MVVM_C
import XCTest

class PokemonResultsTests: XCTestCase, DecodableTestCase {
	
	var dictionary: NSDictionary!
	var sut: PokemonResult!

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
	
	func testDecodableSetsAccurateResultsCount() {
		XCTAssertEqual(sut.results.count, 20)
	}

    override func tearDown() {
		dictionary = nil
		sut = nil
		super.tearDown()
    }
}
