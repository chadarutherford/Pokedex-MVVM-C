//
//  PokemonTests.swift
//  Pokedex-MVVM-CTests
//
//  Created by Chad Rutherford on 10/9/20.
//

@testable import Pokedex_MVVM_C
import XCTest

class PokemonTests: XCTestCase, DecodableTestCase {
	
	var dictionary: NSDictionary!
	var sut: Pokemon!

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
	
	func testDecodableSetsName() throws {
		try XCTAssertEqualToAny(sut.name, dictionary["name"])
	}
	
	func testDecodableSetsURL() throws {
		try XCTAssertEqualToURL(sut.url!, dictionary["url"])
	}

    override func tearDown() {
		dictionary = nil
		sut = nil
		super.tearDown()
    }
}
